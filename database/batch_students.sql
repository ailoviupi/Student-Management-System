USE student_db;

-- 姓氏和名字库
SET @surnames = '赵,钱,孙,李,周,吴,郑,王,冯,陈,褚,卫,蒋,沈,韩,杨,朱,秦,尤,许,何,吕,施,张,孔,曹,严,华,金,魏,陶,姜,戚,谢,邹,喻,柏,水,窦,章,云,苏,潘,葛,奚,范,彭,郎,鲁,韦,昌,马,苗,凤,花,方,俞,任,袁,柳,酆,鲍,史,唐,费,廉,岑,薛,雷,贺,倪,汤,滕,殷,罗,毕,郝,邬,安,常,乐,于,时,傅,皮,卞,齐,康,伍,余,元,卜,顾,孟,平,黄,和,穆,萧,尹,姚,邵,湛,汪,祁,毛,禹,狄,米,贝,明,臧,计,伏,成,戴,谈,宋,茅,庞,熊,纪,舒,屈,项,祝,董,梁,杜,阮,蓝,闵,席,季,麻,强,贾,路,娄,危,江,童,颜,郭,梅,盛,林,刁,钟,徐,邱,骆,高,夏,蔡,田,樊,胡,凌,霍,虞,万,支,柯,昝,管,卢,莫,经,房,裘,缪,干,解,应,宗,丁,宣,贲,邓,郁,单,杭,洪,包,诸,左,石,崔,吉,钮,龚,程,嵇,邢,滑,裴,陆,荣,翁,荀,羊,於,惠,甄,曲,家,封,芮,羿,储,靳,汲,邴,糜,松,井,段,富,巫,乌,焦,巴,弓,牧,隗,山,谷,车,侯,宓,蓬,全,郗,班,仰,秋,仲,伊,宫,宁,仇,栾,暴,甘,钭,厉,戎,祖,武,符,刘,景,詹,束,龙,叶,幸,司,韶,郜,黎,蓟,薄,印,宿,白,怀,蒲,邰,从,鄂,索,咸,籍,赖,卓,蔺,屠,蒙,池,乔,阴,郁,胥,能,苍,双,闻,莘,党,翟,谭,贡,劳,逄,姬,申,扶,堵,冉,宰,郦,雍,郤,璩,桑,桂,濮,牛,寿,通,边,扈,燕,冀,郏,浦,尚,农,温,别,庄,晏,柴,瞿,阎,充,慕,连,茹,习,宦,艾,鱼,容,向,古,易,慎,戈,廖,庾,终,暨,居,衡,步,都,耿,满,弘,匡,国,文,寇,广,禄,阙,东,欧,殳,沃,利,蔚,越,夔,隆,师,巩,厍,聂,晁,勾,敖,融,冷,訾,辛,阚,那,简,饶,空,曾,毋,沙,乜,养,鞠,须,丰,巢,关,蒯,相,查,后,荆,红,游,竺,权,逯,盖,益,桓,公';
SET @male_names = '伟,强,磊,军,洋,勇,杰,涛,超,明,辉,刚,平,健,俊,峰,建,华,文,斌,波,龙,鹏,宇,浩,凯,昊,天,泽,轩,辰,睿,梓,皓,宇航,子轩,浩然,博文,俊杰,明轩,志强,鹏飞,建国,建军,建华,志强,志远,志明,志伟,志刚';
SET @female_names = '芳,娜,敏,静,丽,强,艳,娟,霞,秀,玲,燕,华,梅,莉,婷,雪,颖,倩,慧,晶,莹,琳,洁,蓉,薇,蕾,瑶,珊,珍,珠,玉,玲,珊,珊珊,婷婷,娜娜,静静,敏敏,丽丽,芳芳,秀秀,梅梅,雪雪,颖颖,倩倩,晶晶,莹莹,琳琳,洁洁';

-- 为每个班级插入学生，直到50人
-- 班级1: 计算机1班 (已有2人，需48人)
-- 班级2: 计算机2班 (已有0人，需50人)
-- 班级3: 软件工程1班 (已有0人，需50人)
-- 班级4: 软件高级班 (已有0人，需50人)

DELIMITER $$

DROP PROCEDURE IF EXISTS batch_insert_students$$

CREATE PROCEDURE batch_insert_students()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE class_id INT DEFAULT 1;
    DECLARE student_no_prefix VARCHAR(10);
    DECLARE student_name VARCHAR(50);
    DECLARE gender VARCHAR(10);
    DECLARE phone VARCHAR(20);
    DECLARE email VARCHAR(50);
    DECLARE birth_date DATE;
    DECLARE address VARCHAR(200);
    DECLARE enrollment_date DATE;
    DECLARE class_count INT DEFAULT 4;
    DECLARE target_per_class INT DEFAULT 50;
    DECLARE existing_count INT DEFAULT 0;
    DECLARE need_insert INT DEFAULT 0;
    DECLARE surname VARCHAR(10);
    DECLARE name_part VARCHAR(10);
    DECLARE random_val INT;
    
    -- 班级1
    SET class_id = 1;
    SET student_no_prefix = '2024001';
    SELECT COUNT(*) INTO existing_count FROM student WHERE class_id = class_id;
    SET need_insert = target_per_class - existing_count;
    SET i = 1;
    WHILE i <= need_insert DO
        SET random_val = FLOOR(1 + RAND() * 200);
        SET surname = SUBSTRING_INDEX(SUBSTRING_INDEX(@surnames, ',', random_val), ',', -1);
        IF RAND() > 0.5 THEN
            SET name_part = SUBSTRING_INDEX(SUBSTRING_INDEX(@male_names, ',', FLOOR(1 + RAND() * 50)), ',', -1);
            SET gender = '男';
        ELSE
            SET name_part = SUBSTRING_INDEX(SUBSTRING_INDEX(@female_names, ',', FLOOR(1 + RAND() * 50)), ',', -1);
            SET gender = '女';
        END IF;
        SET student_name = CONCAT(surname, name_part);
        SET phone = CONCAT('1', FLOOR(3 + RAND() * 7), FLOOR(RAND() * 1000000000));
        SET email = CONCAT('student', student_no_prefix, LPAD(i, 3, '0'), '@example.com');
        SET birth_date = DATE_SUB(CURDATE(), INTERVAL FLOOR(18 + RAND() * 5) YEAR);
        SET address = CONCAT('北京市海淀区', FLOOR(1 + RAND() * 100), '号');
        SET enrollment_date = DATE_SUB(CURDATE(), INTERVAL FLOOR(1 + RAND() * 3) YEAR);
        
        INSERT INTO student (student_no, name, gender, age, phone, email, address, enrollment_date, class_id, student_status) 
        VALUES (CONCAT(student_no_prefix, LPAD(i, 3, '0')), student_name, gender, FLOOR(18 + RAND() * 5), phone, email, address, enrollment_date, class_id, '在读');
        
        SET i = i + 1;
    END WHILE;
    
    -- 班级2
    SET class_id = 2;
    SET student_no_prefix = '2024002';
    SELECT COUNT(*) INTO existing_count FROM student WHERE class_id = class_id;
    SET need_insert = target_per_class - existing_count;
    SET i = 1;
    WHILE i <= need_insert DO
        SET random_val = FLOOR(1 + RAND() * 200);
        SET surname = SUBSTRING_INDEX(SUBSTRING_INDEX(@surnames, ',', random_val), ',', -1);
        IF RAND() > 0.5 THEN
            SET name_part = SUBSTRING_INDEX(SUBSTRING_INDEX(@male_names, ',', FLOOR(1 + RAND() * 50)), ',', -1);
            SET gender = '男';
        ELSE
            SET name_part = SUBSTRING_INDEX(SUBSTRING_INDEX(@female_names, ',', FLOOR(1 + RAND() * 50)), ',', -1);
            SET gender = '女';
        END IF;
        SET student_name = CONCAT(surname, name_part);
        SET phone = CONCAT('1', FLOOR(3 + RAND() * 7), FLOOR(RAND() * 1000000000));
        SET email = CONCAT('student', student_no_prefix, LPAD(i, 3, '0'), '@example.com');
        SET birth_date = DATE_SUB(CURDATE(), INTERVAL FLOOR(18 + RAND() * 5) YEAR);
        SET address = CONCAT('北京市朝阳区', FLOOR(1 + RAND() * 100), '号');
        SET enrollment_date = DATE_SUB(CURDATE(), INTERVAL FLOOR(1 + RAND() * 3) YEAR);
        
        INSERT INTO student (student_no, name, gender, age, phone, email, address, enrollment_date, class_id, student_status) 
        VALUES (CONCAT(student_no_prefix, LPAD(i, 3, '0')), student_name, gender, FLOOR(18 + RAND() * 5), phone, email, address, enrollment_date, class_id, '在读');
        
        SET i = i + 1;
    END WHILE;
    
    -- 班级3
    SET class_id = 3;
    SET student_no_prefix = '2024003';
    SELECT COUNT(*) INTO existing_count FROM student WHERE class_id = class_id;
    SET need_insert = target_per_class - existing_count;
    SET i = 1;
    WHILE i <= need_insert DO
        SET random_val = FLOOR(1 + RAND() * 200);
        SET surname = SUBSTRING_INDEX(SUBSTRING_INDEX(@surnames, ',', random_val), ',', -1);
        IF RAND() > 0.5 THEN
            SET name_part = SUBSTRING_INDEX(SUBSTRING_INDEX(@male_names, ',', FLOOR(1 + RAND() * 50)), ',', -1);
            SET gender = '男';
        ELSE
            SET name_part = SUBSTRING_INDEX(SUBSTRING_INDEX(@female_names, ',', FLOOR(1 + RAND() * 50)), ',', -1);
            SET gender = '女';
        END IF;
        SET student_name = CONCAT(surname, name_part);
        SET phone = CONCAT('1', FLOOR(3 + RAND() * 7), FLOOR(RAND() * 1000000000));
        SET email = CONCAT('student', student_no_prefix, LPAD(i, 3, '0'), '@example.com');
        SET birth_date = DATE_SUB(CURDATE(), INTERVAL FLOOR(18 + RAND() * 5) YEAR);
        SET address = CONCAT('上海市浦东新区', FLOOR(1 + RAND() * 100), '号');
        SET enrollment_date = DATE_SUB(CURDATE(), INTERVAL FLOOR(1 + RAND() * 3) YEAR);
        
        INSERT INTO student (student_no, name, gender, age, phone, email, address, enrollment_date, class_id, student_status) 
        VALUES (CONCAT(student_no_prefix, LPAD(i, 3, '0')), student_name, gender, FLOOR(18 + RAND() * 5), phone, email, address, enrollment_date, class_id, '在读');
        
        SET i = i + 1;
    END WHILE;
    
    -- 班级4
    SET class_id = 4;
    SET student_no_prefix = '2024004';
    SELECT COUNT(*) INTO existing_count FROM student WHERE class_id = class_id;
    SET need_insert = target_per_class - existing_count;
    SET i = 1;
    WHILE i <= need_insert DO
        SET random_val = FLOOR(1 + RAND() * 200);
        SET surname = SUBSTRING_INDEX(SUBSTRING_INDEX(@surnames, ',', random_val), ',', -1);
        IF RAND() > 0.5 THEN
            SET name_part = SUBSTRING_INDEX(SUBSTRING_INDEX(@male_names, ',', FLOOR(1 + RAND() * 50)), ',', -1);
            SET gender = '男';
        ELSE
            SET name_part = SUBSTRING_INDEX(SUBSTRING_INDEX(@female_names, ',', FLOOR(1 + RAND() * 50)), ',', -1);
            SET gender = '女';
        END IF;
        SET student_name = CONCAT(surname, name_part);
        SET phone = CONCAT('1', FLOOR(3 + RAND() * 7), FLOOR(RAND() * 1000000000));
        SET email = CONCAT('student', student_no_prefix, LPAD(i, 3, '0'), '@example.com');
        SET birth_date = DATE_SUB(CURDATE(), INTERVAL FLOOR(18 + RAND() * 5) YEAR);
        SET address = CONCAT('广州市天河区', FLOOR(1 + RAND() * 100), '号');
        SET enrollment_date = DATE_SUB(CURDATE(), INTERVAL FLOOR(1 + RAND() * 3) YEAR);
        
        INSERT INTO student (student_no, name, gender, age, phone, email, address, enrollment_date, class_id, student_status) 
        VALUES (CONCAT(student_no_prefix, LPAD(i, 3, '0')), student_name, gender, FLOOR(18 + RAND() * 5), phone, email, address, enrollment_date, class_id, '在读');
        
        SET i = i + 1;
    END WHILE;
    
END$$

DELIMITER ;

CALL batch_insert_students();

DROP PROCEDURE IF EXISTS batch_insert_students;
