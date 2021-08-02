function mnket_dcm_stats_report(options)
% DCM_REPORT_STATS Various staistical tests on matrices: Kolmogorov smirnov normalacy test and relevant t-tests for matrix coloumns
% BY GABRIELLE A.

%Load regressor matrices from DCM folder and place into the structure mat.all

[~, paths] = mnket_subjects(options);

% mat.all= {pla_params_epsi2,pla_params_epsi3, ket_params_epsi2, ket_params_epsi3};


%% Kolmogorov Smirnov test for normalacy  
%The result H is 1 if the test rejects
%the null hypothesis at the 5% significance level, or 0 otherwise.


% i=size(pla_params_epsi2,2);
% H_pla_epsi2=zeros(6,1);
% 
% for k=1:1:i
%     col=pla_params_epsi2(:,k);
%     colval=kstest(col);
%     H_pla_epsi2(k,:) = colval;
% end
%     
% i=size(pla_params_epsi3,2);
% H_pla_epsi3=zeros(6,1);
% 
% for k=1:1:i
%     col=pla_params_epsi3(:,k);
%     colval=kstest(col);
%     H_pla_epsi3(k,:) = colval;
% end
% 
% i=size(ket_params_epsi2,2);
% H_ket_epsi2=zeros(6,1);
% 
% for k=1:1:i
%     col=ket_params_epsi2(:,k);
%     colval=kstest(col);
%     H_ket_epsi2(k,:) = colval;
% end
%   
% i=size(ket_params_epsi3,2);
% H_ket_epsi3=zeros(6,1);
% 
% for k=1:1:i
%     col=ket_params_epsi3(:,k);
%     colval=kstest(col);
%     H_ket_epsi3(k,:) = colval;
% end


% i=size(pla_params_muhat1,2);
% H_pla_muhat1=zeros(6,1);
% 
%  for k=1:1:i
%      col=(pla_params_muhat1(:,k)- mean(pla_params_muhat1(:,k)))/std(pla_params_muhat1(:,k));
%      colval=kstest(col);
%      H_pla_muhat1(k,:) = colval;
%  end

% i=size(pla_params_muhat3,2);
% H_pla_muhat3=zeros(6,1);
% 
%  for k=1:1:i
%      col=(pla_params_muhat3(:,k)- mean(pla_params_muhat3(:,k)))/std(pla_params_muhat3(:,k));
%      colval=kstest(col);
%      H_pla_muhat3(k,:) = colval;
%  end

i=size(mat_pla,2);
H_pla_pihat=zeros(12,1);

 for k=1:1:i
     col=(mat_pla(:,k)- mean(mat_pla(:,k)))/std(mat_pla(:,k));
     colval=kstest(col);
     H_pla_pihat(k,:) = colval;
 end

% i=size(ket_params_muhat1,2);
% H_ket_muhat1=zeros(6,1);
% 
%  for k=1:1:i
%      col=(ket_params_muhat1(:,k)- mean(ket_params_muhat1(:,k)))/std(ket_params_muhat1(:,k));
%      colval=kstest(col);
%      H_ket_muhat1(k,:) = colval;
%  end
 
% i=size(ket_params_muhat3,2);
% H_ket_muhat3=zeros(6,1);
% 
%  for k=1:1:i
%      col=(ket_params_muhat3(:,k)- mean(ket_params_muhat3(:,k)))/std(ket_params_muhat3(:,k));
%      colval=kstest(col);
%      H_ket_muhat3(k,:) = colval;
%  end
%  
i=size(mat_ket,2);
H_ket_pihat=zeros(12,1);

 for k=1:1:i
     col=(mat_ket(:,k)- mean(mat_ket(:,k)))/std(mat_ket(:,k));
     colval=kstest(col);
     H_ket_pihat(k,:) = colval;
 end
 
%-----Output table of H values------------------%

Parameter_ks=[1;2;3;4;5;6;7;8;9;10;11;12];
H_values=table(Parameter_ks,H_pla_pihat,H_ket_pihat)

%% Hotellings One sample t-test with boneferroni correction(alpha=0.008 for mnket dataset)
num_mat= length(mat.all);
for imat=1:1:num_mat
    current_mat=mat.all(imat);
    adj_mat=cell2mat(current_mat);
    col_num=size(adj_mat,2);
    for icol=1:1:col_num
        col=adj_mat(:,icol);
        HotellingT2(col,0.008);
    end

end

%% One sample t-test with boneferroni correction(alpha=0.008 for mnket dataset)
% t_pla_epsi2=[];
% t_pla_epsi3=[];
% t_ket_epsi2=[];
% t_ket_epsi3=[];

t_pla_muhat1=[];
t_pla_muhat3=[];
t_pla_pihat=[];
t_ket_muhat1=[];
t_ket_muhat3=[];
t_ket_pihat=[];


num_mat= length(mat.all);
for imat=1:1:num_mat
    current_mat=mat.all(imat);
    adj_mat=cell2mat(current_mat);
    col_num=size(adj_mat,2);
    for icol=1:1:col_num
        col=adj_mat(:,icol);
        [h,p]=ttest(col,0.008);
        if imat == 1;
            t_pla_pihat(icol,:)= p;
        elseif imat== 2;
            t_ket_pihat(icol,:)=p;

        end
    end
end

%-----Output table of p values-------%
Parameter_t=[1;2;3;4;5;6;7;8;9]; 
Matrix_p_values = table(Parameter_t,t_pla_pihat,t_ket_pihat);
%% Hotellings Paired t-tests with boneferroni correction(alpha=0.008)

col=1; % change for parameter of interest 

pla_col= mat_pla(:,col);
ket_col=mat_ket(:,col);

% Re-format coloumn data from each matrix 
X=[1 pla_col(1);1 pla_col(2);1 pla_col(3);1 pla_col(4);1 pla_col(5);1 ...
    pla_col(6);1 pla_col(7);1  pla_col(8);1 pla_col(9);1 pla_col(10);1 ...
    pla_col(11);1 pla_col(12);1 pla_col(13);1 pla_col(14);1 ...
    pla_col(15);1 pla_col(16);1 pla_col(17);1 pla_col(18);1 pla_col(19);...
    2 ket_col(1);2 ket_col(2);2 ket_col(3);2 ket_col(4);2 ket_col(5);2 ket_col(6);...
    2 ket_col(7);2 ket_col(8) ;2 ket_col(9);2 ket_col(10);2 ket_col(11);2 ...
    ket_col(12);2 ket_col(13);2 ket_col(14);2 ket_col(15);2 ket_col(16);2 ket_col(17);...
    2 ket_col(18);2 ket_col(19)];



% Input vector X into Hotelling function
HotellingT2(X,0.008)


%% Paired t-test for Epsilon 3 with boneferroni correction (alpha=0.008 for mnket dataset)

col=1; % change for parameter of interest 

pla_col= mat_pla(:,col);
ket_col=mat_ket(:,col);

[h,p,ci,stats]= ttest(pla_col,ket_col,'Alpha', 0.008)


