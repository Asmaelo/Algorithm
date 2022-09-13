clc;
clear;
R1=[11;1;5;21;11;4;19;11;4;5];
R2=[17;1;7;34;18;6;32;18;7;7];
R3=[7;1;3;13;8;3;14;7;4;4];
R4=[27;2;11;53;29;9;51;29;11;12];
R5=[8;1;4;16;9;3;16;9;4;4];
 load mydata;
task={'T1','T2','T3','T4','T5','T6','T7','T8','T9','T10'};
ECT=[0,0,0,0,0];%%Execution completion Time for each resource

%create table contain the tasks and their execution time 
sch=table(R1,R2,R3,R4,R5,'rowNames',task);

R1=[256;35;327;210];
R2=[88;31;96;590];
task={'T1','T2','T3','T4'};
sch=table(R1,R2,'rowNames',task);


crossover=[];
orginTable=sch; %%for save the old table to use it to add task exection time
% the table use only for display to be suitable to reader understand the
% result . "orgin" variable is an array used for processing purpose when we
% want proced scheduling tasks we convert it to arraywith two dimention
% that make our code and program easy to manupolation.

orgin=table2array(sch);
% we display the orgin table before processing
disp(sch);
stop=length(task);%stop condidtion set to number of task when all tasks end
%exection the while will stop. 
method=string(ones(1,10));
j=1;
while stop>0
  
disp('----------------------------');

 R=table2array(sch);

 %calculate the fitness and add it as column in the after 
 %last column in the table and named it "fitness"
 %the fitness to select chromosome where fit_max represents first
 %population have chromosomes same as length of tasks.the min fitness laso
 %is population of chromosome and represent the second population
 %we choose the chromosome according to fitness
 fit_max=max(R,[],2);%first population chromosomes
 fit_min=min(R,[],2);%second population chromosomes
sch.fit_Max=fit_max;%add fitness Max to table
sch.fit_Min=fit_min;%add fitness Min to table
disp(sch)
crossover=sqrt(fit_max.*fit_min);
%%
%part one
%%
mean_task=mean(R,2);
cross_minus_mean=abs(crossover-mean_task);
ss=sum(R,2);
mutation=(ss./(fit_max.*fit_min)).*cross_minus_mean;
L=length(crossover);
%%
%part two
%%
sorted=sort(mutation);
cmin=sorted(1);
cmax=sorted(L);
r1=length(find(abs(mutation-cmin)<abs(cmax-mutation)));%min fit
r2=L-r1;                                         %%max fit
fit=mutation./crossover;
         fit=crossover./(fit_max.*fit_min);
          fit=ss./fit_max./fit_min;
       fit=crossover.*(fit_max-fit_min);
%       fit=mutation.*fit_min;
%     fit=ss./(mutation./crossover);

if(r1<=r2)
[f,R_task]=max(fit);
method(j)="Max";
else
  [f,R_task]=min(fit);
  method(j)="Min";
end
j=j+1;
disp('fitness='+string(f));
disp('Task number='+string( sch.Properties.RowNames(R_task)));

%after that we find the less exection time according to resources(R1,R2,..)
%example   R1  R2
%      T2  3   5   we select 3 because it has less exection time on R1
%
[time,machine_no]=min(R(R_task,:));
exe_time=orgin(R_task,machine_no);
disp("Execution time="+string(exe_time));
disp('Machine Number='+string(machine_no));
disp(string( sch.Properties.RowNames(R_task))+' -----> R'+string(machine_no));
% add exection time to Resource (column) that executed the task 
R(:,machine_no)=R(:,machine_no)+exe_time;
%adding the time of exetion task to ECT
ECT(machine_no)=ECT(machine_no)+exe_time;
%delete the task after exection
R(R_task,:)=[];
%delete the task from orgin scheduling table
orgin(R_task,:)=[];
%remove task from table
task(R_task)=[];
%construct the table after update.
sch=array2table(R,'rowNames',task);
disp('-----------------------------------------------');
disp(sch);
disp('------Orgin-------');
orginTable(orginTable.Properties.RowNames(R_task),:)=[];
disp(orginTable);
disp('-----------------------------------------------');
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
disp(method);
m=5;
    sumall=sum(ECT);
    makespan=max(ECT);
    utilizatoin=sumall/(makespan*m)
for comment_only=0:0
%%
%part one
%che=check if number of chromosomes > mid to select Max-Min method else we
%select Min-Min scheduling method.che will used later for selection purpose
% che=length(find(mutation>=mid));
%now we must select either max or min method according to value of che
% example R1   R2    fit_min   fit_max
%         2    7       2         7     
%         1    3       1         3
%  we select min(fit_min) if che <=mid or select max(fit_min) if che>mid
%  r1=min(abs(crossover-Av_max));
%  r2=min(abs(crossover-Av_min));
%if(che>length(task))
% if(max_rate<=min_rate)
% sub_max_min=fit_max-fit_min;

%part 2
%mutation

% % % % %  s = RandStream('mt19937ar','Seed','shuffle');
% % % % % RandStream.setGlobalStream(s);
% % % % % ra=( 3 + (7)*rand(s,L,1))/100+0.9;
% % % % % mutation=crossover.*ra;
% % % % % mutation=mutation.*abs(fit_max-fit_min);
% % % % % sorted=sort(mutation);
% % % % % cmin=sorted(1);
% % % % % cmax=sorted(L);
% % % % % r1=length(find((mutation-cmin)<(cmax-mutation)));%min fit
% % % % % r2=L-r1;                                         %%max fit
% % % % % 
% % % % % fit=(crossover);
% % % % % if(r1>r2)



end