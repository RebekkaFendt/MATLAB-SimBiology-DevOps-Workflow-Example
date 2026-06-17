classdef tgenerateSimFun < matlab.unittest.TestCase

    properties (Access=private)
        MATfilefullpath
        LoadedData
    end

    properties (ClassSetupParameter)
        MATfilename = {"test_generateSimFun.mat",string.empty}
    end

    properties (TestParameter)
        fieldName = {"simFun","doseTable","dependenciesSimFun"}
    end

    methods (Test)

        function testMATfileCreation(testCase)
            import matlab.unittest.constraints.IsFile;

            % Verify that the MAT file is created
            testCase.verifyThat(testCase.MATfilefullpath, IsFile, ...
                'MAT file was not created.');
        end

        function testSimFunctionCreation(testCase, fieldName)
            import matlab.unittest.constraints.HasField;

            % Verify that the MAT file contains required fields
            testCase.verifyThat(testCase.LoadedData, HasField(fieldName), ...
                fieldName + " should be saved in " + testCase.MATfilefullpath);
        end

        function testSimFunctionAcceleration(testCase)
            % Verify that the SimFunction is accelerated
            simFun = testCase.LoadedData.simFun;
            testCase.verifyReturnsTrue(@()simFun.isAccelerated, ...
                "simFun was not accelerated.");
        end

    end

    methods (TestClassSetup)

        function classSetup(testCase, MATfilename)
            % Set up shared state for all tests.
            import matlab.unittest.fixtures.WorkingFolderFixture;

            % Call generateSimFun without or with input argument
            if isempty(MATfilename)
                testCase.MATfilefullpath = generateSimFun();
            else
                % Generate the simulation function in a working folder
                testCase.applyFixture(WorkingFolderFixture);

                testCase.MATfilefullpath = generateSimFun(MATfilename);
            end

            % Load content of MAT file
            testCase.LoadedData = load(testCase.MATfilefullpath);

        end

    end
end