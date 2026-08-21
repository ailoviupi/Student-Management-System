package com.example.student.mapper;

import com.example.student.entity.TeacherPreference;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface TeacherPreferenceMapper {

    @Select("SELECT * FROM teacher_preference WHERE teacher_id = #{teacherId}")
    TeacherPreference findByTeacherId(@Param("teacherId") Integer teacherId);

    @Select("SELECT * FROM teacher_preference")
    List<TeacherPreference> findAll();

    @Insert("INSERT INTO teacher_preference (teacher_id, preferred_days, preferred_slots, avoided_days, " +
            "avoided_slots, max_daily_hours, max_weekly_hours, allow_consecutive, remark) " +
            "VALUES (#{teacherId}, #{preferredDays}, #{preferredSlots}, #{avoidedDays}, " +
            "#{avoidedSlots}, #{maxDailyHours}, #{maxWeeklyHours}, #{allowConsecutive}, #{remark})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(TeacherPreference preference);

    @Update("UPDATE teacher_preference SET preferred_days = #{preferredDays}, preferred_slots = #{preferredSlots}, " +
            "avoided_days = #{avoidedDays}, avoided_slots = #{avoidedSlots}, max_daily_hours = #{maxDailyHours}, " +
            "max_weekly_hours = #{maxWeeklyHours}, allow_consecutive = #{allowConsecutive}, remark = #{remark} " +
            "WHERE id = #{id}")
    int update(TeacherPreference preference);

    @Delete("DELETE FROM teacher_preference WHERE id = #{id}")
    int deleteById(@Param("id") Integer id);
}
