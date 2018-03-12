package io.irontest.db;

import io.irontest.models.testrun.RegularTestcaseRun;
import io.irontest.models.testrun.TestcaseRun;
import org.skife.jdbi.v2.sqlobject.*;
import org.skife.jdbi.v2.sqlobject.customizers.RegisterMapper;

import java.util.Date;

/**
 * Created by Zheng on 24/07/2016.
 */
@RegisterMapper(TestcaseRunMapper.class)
public abstract class TestcaseRunDAO {
    @SqlUpdate("CREATE SEQUENCE IF NOT EXISTS testcase_run_sequence START WITH 1 INCREMENT BY 1 NOCACHE")
    public abstract void createSequenceIfNotExists();

    @SqlUpdate("CREATE TABLE IF NOT EXISTS testcase_run (id BIGINT DEFAULT testcase_run_sequence.NEXTVAL PRIMARY KEY, " +
            "testcase_id BIGINT NOT NULL, testcase_name varchar(200) NOT NULL, testcase_folderpath CLOB NOT NULL," +
            "starttime TIMESTAMP NOT NULL, duration BIGINT NOT NULL, result varchar(15) NOT NULL, " +
            "created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, " +
            "updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)")
    public abstract void createTableIfNotExists();

    @SqlUpdate("insert into testcase_run " +
            "(testcase_id, testcase_name, testcase_folderpath, starttime, duration, result) values " +
            "(:testcase_id, :testcase_name, :testcase_folderpath, :starttime, :duration, :result)")
    @GetGeneratedKeys
    protected abstract long _insert(@Bind("testcase_id") long testcaseId, @Bind("testcase_name") String testcaseName,
                                    @Bind("testcase_folderpath") String testcaseFolderPath,
                                    @Bind("starttime") Date startTime, @Bind("duration") long duration,
                                    @Bind("result") String result);

    @Transaction
    public void insert(RegularTestcaseRun testcaseRun) {
        //  remove contents that are not to be serialized into the stepRunsJSON
//        List<TeststepRun> stepRuns = testcaseRun.getStepRuns();
//        for (TeststepRun stepRun : stepRuns) {
//            Teststep step = stepRun.getTeststep();
//            step.getAssertions().clear();
//            Endpoint endpoint = step.getEndpoint();
//            if (endpoint != null) {
//                endpoint.setPassword(null);
//            }
//        }

        //  serialize stepRuns into JSON string
//        String stepRunsJSON = new ObjectMapper().writeValueAsString(stepRuns);
        long id = _insert(testcaseRun.getTestcaseId(), testcaseRun.getTestcaseName(), testcaseRun.getTestcaseFolderPath(), testcaseRun.getStartTime(),
                testcaseRun.getDuration(), testcaseRun.getResult().toString());
        testcaseRun.setId(id);
    }

    @SqlQuery("select * from testcase_run where id = :id")
    public abstract TestcaseRun findById(@Bind("id") long id);

    @SqlQuery("select top 1 * from testcase_run where testcase_id = :testcaseId order by starttime desc")
    public abstract TestcaseRun findLastByTestcaseId(@Bind("testcaseId") long testcaseId);
}
