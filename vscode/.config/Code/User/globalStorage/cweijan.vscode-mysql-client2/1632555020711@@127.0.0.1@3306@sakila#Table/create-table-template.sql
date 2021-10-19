CREATE TABLE [name](  
    id int NOT NULL primary key AUTO_INCREMENT comment 'primary key',
    create_time DATETIME COMMENT 'create time',
    update_time DATETIME COMMENT 'update time',
    [column] varchar(255) comment ''
) default charset utf8 comment '';