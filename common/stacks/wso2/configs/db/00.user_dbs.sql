CREATE USER wso2carbon with encrypted password 'wso2carbon';

CREATE DATABASE shared_db;
CREATE DATABASE identity_db;
CREATE DATABASE bps_db;
CREATE DATABASE analytics_db;
CREATE DATABASE geolocation_db;

GRANT ALL PRIVILEGES ON DATABASE shared_db TO wso2carbon;
GRANT ALL PRIVILEGES ON DATABASE identity_db TO wso2carbon;
GRANT ALL PRIVILEGES ON DATABASE bps_db TO wso2carbon;
GRANT ALL PRIVILEGES ON DATABASE analytics_db TO wso2carbon;
GRANT ALL PRIVILEGES ON DATABASE geolocation_db TO wso2carbon;
