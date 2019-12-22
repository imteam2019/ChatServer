# -*- coding:utf-8 -*-
'''
Created on 2017年11月21日

@author: Administrator
'''
from DBUtils.PooledDB import PooledDB
import MySQLdb.cursors

database_ip = "127.0.0.1"
database_user = 'root'
database_password = 'contain'
database_name = 'ChartDB'

pool = PooledDB(
    MySQLdb,
    10,
    host=database_ip,
    user=database_user,
    passwd=database_password,
    db=database_name,
    charset="utf8",
    cursorclass=MySQLdb.cursors.DictCursor)

if __name__ == '__main__':
    pass
