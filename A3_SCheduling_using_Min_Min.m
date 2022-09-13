%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%                                     %%%%%%%%%%%%%%%%
%%%%%%%%%%%%     Min-Min Scheduling Algorithm    %%%%%%%%%%%%%%%%
%%%%%%%%%%%%                                     %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
R1=[11;1;5;21;11;4;19;11;4;5];
R2=[17;1;7;34;18;6;32;18;7;7];
R3=[7;1;3;13;8;3;14;7;4;4];
R4=[27;2;11;53;29;9;51;29;11;12];
R5=[8;1;4;16;9;3;16;9;4;4];
 load mydata;

task={'T1','T2','T3','T4','T5','T6','T7','T8','T9','T10'};
ECT=[0,0,0,0,0];%%Execution completion Time for each resource
sch=table(R1,R2,R3,R4,R5,'rowNames',task);


R1=[256;35;327;210];
R2=[88;31;96;590];
task={'T1','T2','T3','T4'};
sch=table(R1,R2,'rowNames',task);


orginTable=sch; %%for hold the table before update only.
%at this stage we construct the table of task and assign resources 
%sch is a table have fields(columns) of mashines(resources) in this example
%is has M1 ,M2,M3,M4,M5,M6,M7,M8,M9,M10or(R1,R2,R3,R4,R5,R6,R7,R8,R9,R10)
%the rows  represent the tasks , where each row is represent a time for 
%running that task over all machines(resources)
% orgin use to save the old table because the sch table will get update
%when task run on specific machine we must remove that task from table
%and update the table to new values so that orgin always have same orgin
%table values 
orgin=table2array(sch);
disp(sch);
stop=length(task);
while stop>0
    
disp('----------------------------');
%we convert table to array In order to be able to perform operations on array,
%we perform operations on array because MATLAB has many functions 
%that can be applied to array. 
 R=table2array(sch);
 %fitness is the min time(value) that a task run on a single machime
 %Here we will find all the minimum execution times for all tasks. 
 %Each task has an execution time that varies from one source to another 
 %so we find a machine that execute a task with minimum time 
 fit=min(R,[],2); %output is array contain min execution time to run task on specific machine 
  
 %add the fitness as column to end of table "sch". 
sch.fit=fit;
disp(sch)
% find the min fitness to display it on matlap command window.
%R_task= is the row position of min value and represent the task(Tr) that will
%be execute first.
%f=the min value.
[f,R_task]=min(fit);
disp('fitness='+string(f));
disp('Task number='+string( sch.Properties.RowNames(R_task)));

%now we find the machine number Mi that execute the task (Tr)

[time,machine_no]=min(R(R_task,:));
exe_time=orgin(R_task,machine_no);
disp("Execution time="+string(exe_time));
disp('Machine Number='+string(machine_no));
disp(string( sch.Properties.RowNames(R_task))+' -----> R'+string(machine_no));

%after execute the task Tr on machine Mi
%we must add the time of execution to time of all task that run on machine Mi

R(:,machine_no)=R(:,machine_no)+exe_time;
%adding the time of exetion task to ECT
ECT(machine_no)=ECT(machine_no)+exe_time;
%remove the executed task from table i.e remove row from table "sch"
R(R_task,:)=[];
orgin(R_task,:)=[];
% remove task label (example task T1)
task(R_task)=[];
sch=array2table(R,'rowNames',task);
disp('--------------------------------------------');
disp(sch);
disp('------Orgin-------');
orginTable(orginTable.Properties.RowNames(R_task),:)=[];
disp(orginTable);
disp('--------------------------------------------');
stop=length(task);
end
disp('-----------------------------------------------');
disp('    Execution Completion Time for Machines     ');
disp('-----------------------------------------------');
disp('       R1   R2   R3   R4   R5');
disp(['       ' num2str(ECT(1)) '   ' num2str(ECT(2)) ...
'   ' num2str(ECT(3)) '   ' num2str(ECT(4)) '   ' num2str(ECT(5))])

c = categorical({'R1','R2','R3','R4','R5'});
bar(c,ECT,'b')
m=5;
    sumall=sum(ECT);
    makespan=max(ECT);
    utilizatoin=sumall/(makespan*m)

