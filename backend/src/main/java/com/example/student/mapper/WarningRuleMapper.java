package com.example.student.mapper;

import com.example.student.entity.WarningRule;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface WarningRuleMapper {
    
    @Select("SELECT * FROM warning_rule WHERE status = 1")
    List<WarningRule> findAllActive();
    
    @Select("SELECT * FROM warning_rule")
    List<WarningRule> findAll();
    
    @Select("SELECT * FROM warning_rule WHERE id = #{id}")
    WarningRule findById(Integer id);
    
    @Insert("INSERT INTO warning_rule (rule_name, rule_type, warning_level, threshold_value, " +
            "threshold_count, description, status) " +
            "VALUES (#{ruleName}, #{ruleType}, #{warningLevel}, #{thresholdValue}, " +
            "#{thresholdCount}, #{description}, #{status})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(WarningRule rule);
    
    @Update("UPDATE warning_rule SET rule_name = #{ruleName}, rule_type = #{ruleType}, " +
            "warning_level = #{warningLevel}, threshold_value = #{thresholdValue}, " +
            "threshold_count = #{thresholdCount}, description = #{description}, " +
            "status = #{status} WHERE id = #{id}")
    int update(WarningRule rule);
    
    @Delete("DELETE FROM warning_rule WHERE id = #{id}")
    int deleteById(Integer id);
}
