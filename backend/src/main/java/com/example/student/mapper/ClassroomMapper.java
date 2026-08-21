package com.example.student.mapper;

import com.example.student.entity.Classroom;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface ClassroomMapper {
    
    @Select("SELECT * FROM classroom WHERE status = 1")
    List<Classroom> findAllActive();
    
    @Select("SELECT * FROM classroom")
    List<Classroom> findAll();
    
    @Select("SELECT * FROM classroom WHERE id = #{id}")
    Classroom findById(Integer id);
    
    @Insert("INSERT INTO classroom (room_code, room_name, building, floor, capacity, room_type, status) " +
            "VALUES (#{roomCode}, #{roomName}, #{building}, #{floor}, #{capacity}, #{roomType}, #{status})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Classroom classroom);
    
    @Update("UPDATE classroom SET room_code = #{roomCode}, room_name = #{roomName}, building = #{building}, " +
            "floor = #{floor}, capacity = #{capacity}, room_type = #{roomType}, status = #{status} WHERE id = #{id}")
    int update(Classroom classroom);
    
    @Delete("DELETE FROM classroom WHERE id = #{id}")
    int deleteById(Integer id);
}
