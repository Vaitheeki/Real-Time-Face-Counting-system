function [ msg ] = DataAccess( username, password )
%DB Service Port, Username, Password
host = 'localhost:3306';
user = 'root';
psw = '';

%Database Name
dbname = 'test';

%JDBC Parameters
jdbcString = sprintf('jdbc:mysql://%s/%s', host, dbname);
jdbcDriver = 'com.mysql.jdbc.Driver';

%Path to mysql Connector
javaclasspath = ('mysql-connector-java-5.1.46-bin.jar');

%Now making DB connection Object
dbConn = database(dbname, user, psw, jdbcDriver, jdbcString);

%checking Connection Status
dbStatus = isopen(dbConn);
if (dbStatus==0)
    msg = sprintf('Error to estabilish the connection.\nReason: %s', dbConn.Message);
        passtolog = makelog('Connection failed',msg);

    msgbox(msg);
    return
end
%Selecting Query username
QUERY = ['select userName from test.login where userName = ' ++ ' "' ++  username  ++ '" ' ++ ' and password = ' ++ ' "' ++  password  ++ '" ' ];
disp(QUERY);
rs = fetch(dbConn, QUERY);
if isempty(rs)
    msg = 0;
    u='';

else
    msg = 0;
    u = rs;
end
    

QUERY = ['select password from test.login where userName = ' ++ ' "' ++  username  ++ '" ' ++ ' and password = ' ++ ' "' ++  password  ++ '" ' ];
disp(QUERY);
rs = fetch(dbConn, QUERY);
if isempty(rs)
    msg = 0;
    p='';


else
    p = rs;
end

%comparing Username and Password
UserName = strcmp(username,u);
Password = strcmp(password,p);
    if UserName == 1 && Password == 1
        msg = 1;
    else
        msg = 0;
    end
    
%closing connection
close(dbConn);

end