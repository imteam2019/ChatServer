# coding=utf-8
'''
Created on 2017年6月14日

@author: yhait
'''
import json
import logging
import md5
import sndhdr
import socket
import time
import uuid

import MySQLdb
import MySQLdb.cursors
import web

from common import myredis
import database
import log
import request
import session
import urllib2
import urllib

urls = (
    "/", "LoginRequest"
)


class LoginRequest(request.Request):

    def __init__(self):
        super(LoginRequest, self).__init__()

    def post_request_proc(self, message_content):
        try:
            request = json.loads(message_content)
            proc_result = self.login_request_proc(request)
            if proc_result is False:
                return (1, '用户名或者密码不正确')
            else:
                return (0, proc_result)
        except ValueError, e:
            logging.warn(e)
            return (2, '请求格式不正确,解密后不是json')
        except KeyError as e:
            logging.warn(e)
            return (3, '请求缺少用户名或者密码信息')
        except MySQLdb.Error as e:
            logging.warn(e)
            return (4, '数据库异常')
        except socket.error as e:
            logging.warn(e)
            return (6, '服务器网络故障')
        except Exception as e:
            logging.warn(e)
            return (5, '其他未知的错误')

    def login_request_proc(self, request):
        loginname = request['loginname']
        password = request['password']
        device = 'mobile'
        if 'device' in request:
            device = request['device']
        user_info = self.get_user_info_from_db(loginname)
        if user_info is None:
            return False
        elif password.lower() != user_info['password'].lower():
            return False
        else:
            user_id = user_info['id']
            user_code = self.get_user_code(user_id)
            user_type = user_info['user_type']
#             session = self.get_session(user_id, device)  # 生成session
            session = self.create_session()
            try:
                post_str = self.postHttp(user_id, session, device)
                if json.loads(post_str)['code'] != 0:
                    return False
            except Exception as e:
                logging.warn(e)
                logging.warn("post task server failed.")
            self.save_login_history(user_id, session, device)  # 保存登录信息
            self.save_new_session(user_id, session, device)  # 更新用户新的session
            login_info = self.get_login_info(user_info, session, user_type, user_code) 
            self.update_user_data_to_redis(user_id, device, session)
            return login_info

    def save_login_history(self, user_id, session, device):
        db_connect = database.pool.connection()
        cursor = db_connect.cursor()
        db_connect.begin()
        try:
            sql = "insert into tb_login_history (user_id, session, time, device) values (%d, '%s', '%s', '%s')" % (
                user_id, session, time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()), device)
            cursor.execute(sql)
            db_connect.commit()
        except MySQLdb:
            db_connect.rollback()
            raise
        finally:
            cursor.close()
            db_connect.close()
            
    def get_user_code(self, user_id):
        db_connect = database.pool.connection()
        cursor = db_connect.cursor()
        try:
            sql = "select * from tb_user_code where id = %d" % user_id
            cursor.execute(sql)
            code_info = cursor.fetchone()
            return code_info['code']
        except MySQLdb:
            raise
        finally:
            cursor.close()
            db_connect.close()

    def get_login_info(self, user_info, session, user_type, user_code):
        result = {}
        result['id'] = user_info['id']
        result['state'] = user_info['state']
        result['s_type'] = user_info['s_type']
        result['session'] = session
        result['password'] = self.get_password(session)
        result['user_type'] = user_type
        result['user_code'] = user_code
        return json.dumps(result)

    def get_session(self, user_id, device):
        return session.get_session_from_msg_server(user_id, device)

    def save_new_session(self, user_id, user_session, device):
        db_connect = database.pool.connection()
        cursor = db_connect.cursor()
        db_connect.begin()
        try:
            sql = "select count(*) from tb_user_session where user_id = %d and device = '%s'" % (
                user_id, device)
            cursor.execute(sql)
            data = cursor.fetchone()
            if(data['count(*)'] == 0):
                sql = "insert into tb_user_session (user_id, session, time, device) values (%d, '%s', '%s', '%s')" % (
                    user_id, user_session, time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()), device)
            else:
                sql = "update tb_user_session set session = '%s', time = '%s' where user_id = %d and device = '%s'" % (
                    user_session, time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()), user_id, device)
            cursor.execute(sql)
            db_connect.commit()
        except MySQLdb:
            db_connect.rollback()
            raise
        finally:
            cursor.close()
            db_connect.close()

    def get_password(self, info):
        return md5.get_md5(info)

    def get_user_info_from_db(self, loginname):
        db_connect = database.pool.connection()
        cursor = db_connect.cursor()
        try:
            sql = "select * from tb_user where telephone = '%s' or username = '%s' or email = '%s'" % (
                loginname, loginname, loginname)
            cursor.execute(sql)
            user_info = cursor.fetchone()
            return user_info
        except MySQLdb:
            raise
        finally:
            cursor.close()
            db_connect.close()
            
    def create_session(self):
        uuid1 = md5.get_md5(str(uuid.uuid1()))
        return uuid1
            
    def update_user_data_to_redis(self, user_id, device, session):
        user_id_type = '%d_%s' % (user_id, device)
        # 查看是否已经登录，移除老的session,添加新的session
        sn = myredis.get_user_id_type_session(user_id_type)
        if sn is not None:
            myredis.remove_session(sn)
        myredis.add_session(session)
        myredis.set_user_id_type_session(user_id_type, session)
        myredis.initialization_user_id_type_message_id(user_id_type)

    def postHttp(self, user_id, session, device):
        url = 'http://tapi.anysa.co/api/member.ashx?action=changesession'
        utype = 2
        if device == "pc":
            utype = 1
        elif device == 'mobile':
            utype = 2
        postdata = dict(id=user_id, session=session, utype=utype)
        # url编码
        postdata = urllib.urlencode(postdata)
        # enable cookie
        request = urllib2.Request(url, postdata)
        response = urllib2.urlopen(request)
        return response.read()


app = web.application(urls, locals())

if __name__ == '__main__':
    app.run()
