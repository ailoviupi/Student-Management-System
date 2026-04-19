package com.example.student.controller;

import com.alibaba.excel.EasyExcel;
import com.example.student.common.Result;
import com.example.student.dto.ScoreQueryDTO;
import com.example.student.entity.Score;
import com.example.student.service.ScoreService;
import com.example.student.vo.PageVO;
import com.example.student.vo.ScoreExportVO;
import com.example.student.vo.ScoreRankVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/scores")
@CrossOrigin
public class ScoreController {
    
    @Autowired
    private ScoreService scoreService;
    
    @GetMapping
    public Result<PageVO<Score>> list(ScoreQueryDTO queryDTO) {
        return Result.success(scoreService.findByCondition(queryDTO));
    }
    
    @GetMapping("/{id}")
    public Result<Score> getById(@PathVariable Integer id) {
        Score score = scoreService.findById(id);
        if (score != null) {
            return Result.success(score);
        }
        return Result.error("成绩记录不存在");
    }
    
    @PostMapping
    public Result<Void> save(@RequestBody Score score) {
        if (scoreService.save(score)) {
            return Result.success();
        }
        return Result.error("新增失败");
    }
    
    @PutMapping
    public Result<Void> update(@RequestBody Score score) {
        if (scoreService.update(score)) {
            return Result.success();
        }
        return Result.error("修改失败");
    }
    
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Integer id) {
        if (scoreService.deleteById(id)) {
            return Result.success();
        }
        return Result.error("删除失败");
    }
    
    @GetMapping("/statistics")
    public Result<Map<String, Object>> getStatistics() {
        return Result.success(scoreService.getStatistics());
    }
    
    @GetMapping("/export")
    public void export(HttpServletResponse response) throws IOException {
        List<Score> scores = scoreService.findAllForExport();
        
        List<ScoreExportVO> exportList = scores.stream().map(score -> {
            ScoreExportVO vo = new ScoreExportVO();
            vo.setStudentNo(score.getStudentNo());
            vo.setStudentName(score.getStudentName());
            vo.setClassName(score.getClassName());
            vo.setCourseCode(score.getCourseCode());
            vo.setCourseName(score.getCourseName());
            vo.setScore(score.getScore());
            vo.setExamType(score.getExamType());
            vo.setExamDate(score.getExamDate() != null ? score.getExamDate().toString() : "");
            vo.setRemark(score.getRemark());
            return vo;
        }).collect(Collectors.toList());
        
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("utf-8");
        String fileName = URLEncoder.encode("成绩报表", "UTF-8").replaceAll("\\+", "%20");
        response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");
        
        EasyExcel.write(response.getOutputStream(), ScoreExportVO.class).sheet("成绩数据").doWrite(exportList);
    }
    
    @GetMapping("/rank/course/{courseId}")
    public Result<List<ScoreRankVO>> getRankByCourse(@PathVariable Integer courseId) {
        return Result.success(scoreService.findRankByCourse(courseId));
    }
    
    @GetMapping("/rank/overall")
    public Result<List<ScoreRankVO>> getOverallRank() {
        return Result.success(scoreService.findOverallRank());
    }
    
    @GetMapping("/analysis")
    public Result<Map<String, Object>> getScoreAnalysis() {
        return Result.success(scoreService.getScoreAnalysis());
    }
    
    // 学生端接口：获取当前登录学生的成绩
    @GetMapping("/my-scores")
    public Result<List<Score>> getMyScores(@RequestAttribute("username") String username,
                                           @RequestAttribute("role") String role) {
        if (!"student".equals(role)) {
            return Result.error("无权访问");
        }
        return Result.success(scoreService.findByStudentNo(username));
    }
    
    // 学生端接口：获取当前登录学生的成绩统计
    @GetMapping("/my-statistics")
    public Result<Map<String, Object>> getMyStatistics(@RequestAttribute("username") String username,
                                                       @RequestAttribute("role") String role) {
        if (!"student".equals(role)) {
            return Result.error("无权访问");
        }
        return Result.success(scoreService.getStudentStatistics(username));
    }
}
