function [ msg ] = DBCon
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
    msgbox(msg);
    return
end
% Query='SELECT * FROM login'
% rs=fetch(dbConn,Query)
% if (isempty (rs))
%     msgbox('No data exists');
%     return
% end
%data insert 
% colnames ={'userName','password'};
% data={'vimal','1234'};
% datainsert(dbConn,'login',colnames,data);
% msg=1;
%closing connection
close(dbConn);

end

