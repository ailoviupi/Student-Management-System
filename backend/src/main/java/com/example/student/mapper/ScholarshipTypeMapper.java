package com.example.student.mapper;

import com.example.student.entity.ScholarshipType;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface ScholarshipTypeMapper {
    
    @Select("SELECT * FROM scholarship_type WHERE status = 1")
    List<ScholarshipType> findAllActive();
    
    @Select("SELECT * FROM scholarship_type")
    List<ScholarshipType> findAll();
    
    @Select("SELECT * FROM scholarship_type WHERE id = #{id}")
    ScholarshipType findById(Integer id);
    
    @Insert("INSERT INTO scholarship_type (type_name, type_code, amount, quota, description, requirements, academic_year, semester, status) " +
            "VALUES (#{typeName}, #{typeCode}, #{amount}, #{quota}, #{description}, #{requirements}, #{academicYear}, #{semester}, #{status})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(ScholarshipType type);
    
    @Update("UPDATE scholarship_type SET type_name = #{typeName}, type_code = #{typeCode}, amount = #{amount}, " +
            "quota = #{quota}, description = #{description}, requirements = #{requirements}, " +
            "academic_year = #{academicYear}, semester = #{semester}, status = #{status} WHERE id = #{id}")
    int update(ScholarshipType type);
    
    @Delete("DELETE FROM scholarship_type WHERE id = #{id}")
    int deleteById(Integer id);
}
