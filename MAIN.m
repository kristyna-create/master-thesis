clc;
clear;

cd 'C:\Code_Master_Thesis'

% Add path of data and functions
addpath('data');
addpath('functions');

%-------------------------------PRELIMINARIES--------------------------------------
forgetting = 2;    % 1: use constant factor; 2: use variable factor

lambda = 0.9963;     % Forgetting factor for the state equation variance
kappa = 0.96;      % Decay factor for measurement error variance

eta = 0.9963;   % Forgetting factor for DPS (dynamic prior selection) and DMA

% Please choose:
p = 4;             % p is number of lags in the VAR part
nos = 3;           % number of subsets to consider (default is 3, i.e. 3, 7, and 25 variable VARs)
% if nos=1 you might want a single model. Which one is this?
single = 1;        % 1: 3 variable VAR
                   % 2: 7 variable VAR
                   % 3: 25 variable VAR
                   
prior = 1;         % 1: Use Koop-type Minnesota prior
                   % 2: Use Litterman-type Minnesota prior
                         
% Choose which results to print
% NOTE: CHOOSE ONLY 0/1 (FOR NO/YES) VALUES!
print_coefficients = 1;   % plot volatilities and lambda_t (but not theta_t which is huge)
print_Min = 1;            % print the Minnesota prior over time

%----------------------------------LOAD DATA----------------------------------------
load ydata.mat;
load ynames.mat;
load tcode.mat;
load vars.mat;

%find key interest rate position   
IndexC = strfind(ynames, 'Wu-Xia Shadow Rate');
irate_pos = find(not(cellfun('isempty', IndexC))); 
%position of Wu-Xia shadow rate among variables
%will be useful for setting the shock to this rate in impulse response
%analysis

%specify the shock to policy rate - in percentage points
irate_shock = -1;

% Create dates variable
start_date = 1999;   %for January 1999
end_date = 2017 + 3/12;  %for April 2017
yearlab = (start_date:1/12:end_date)'; 
T0 = 40; %size of the training sample

% xlswrite('tcodes',ydata,'Sheet1','A1');
% Y0 = ydata(:,vars{3,1});
% xlswrite('adf_kpss_level',Y0,'Sheet1','A1');
% xlswrite('ipi_L',ydata(:,17),'Sheet1','A1');
% xlswrite('ma_gdp_L',ydata(:,44),'Sheet1','A1');
% xlswrite('fhfa_hpi_L',ydata(:,46),'Sheet1','A1');
% xlswrite('krippner_ssr_L',ydata(:,25),'Sheet1','A1');


% Transform data to stationarity
% Y: standard transformations (for iterated forecasts, and RHS of direct forecasts)
[Y,yearlab] = transform(ydata,tcode,yearlab);

% Select a subset of the data to be used for the VAR
if nos>3
    error('DMA over too many models, memory concerns...')
end
Y1=cell(nos,1);

st_dev = std(Y(1:T0,:),1)'; %column of standard deviations for all variables
Ytemp = standardize1(Y,T0); 


M = zeros(nos,1);
for ss = 1:nos
    if nos ~= 1
        single = ss;
    end
    select_subset = vars{single,1};
    Y1{ss,1} = Ytemp(:,select_subset);
    M(ss,1) = max(size(select_subset)); % M is the dimensionality of Y
end
t = size(Y1{1,1},1);

%  xlswrite('adf_kpss_transformed',Y1{3,1},'Sheet1','A1');
%  xlswrite('ipi_Tr',Ytemp(:,17),'Sheet1','A1');
%  xlswrite('ma_gdp_Tr',Ytemp(:,44),'Sheet1','A1');
%  xlswrite('fhfa_hpi_Tr',Ytemp(:,46),'Sheet1','A1');
%  xlswrite('krippner_ssr_Tr',Ytemp(:,25),'Sheet1','A1');
%  [h,pValue] = adftest(Ytemp(:,27))
%  [h,pValue] = vratiotest(Ytemp(:,2))

%choose model which best predicts variables in vars_pred
vars_pred = vars{1,1}; %variables we are interested in predicting, default are the small-VAR variables
%it must be the subset of small-VAR variables
%Now we will find the position of those variables in each of the
%small/medium/large VAR
vars_pred_pos = cell(nos,1);

for ss=1:nos
    for i=1:length(vars_pred)
        vars_pred_pos{ss,1}(i,1) = find(vars{ss,1} == vars_pred(i,1));
    end
end


% ===================================| VAR EQUATION |==============================
% Generate lagged Y matrix. This will be part of the X matrix
x_t = cell(nos,1);
x_f = cell(nos,1);
y_t = cell(nos,1);
K = zeros(nos,1);
for ss=1:nos
    ylag = mlag2(Y1{ss,1},p); 
    ylag = ylag(p+1:end,:);
    [temp,kk] = create_RHS(ylag,M(ss),p,t);
    x_t{ss,1} = temp;
    K(ss,1) = kk;
    x_f{ss,1} = ylag;
    y_t{ss,1} = Y1{ss,1}(p+1:end,:);
end
yearlab = yearlab(p+1:end);
% Time series observations
t=size(y_t{1,1},1); 

   
%----------------------------PRELIMINARIES---------------------------------
%========= PRIORS:
% Set the alpha_bar and the set of gamma values
alpha_bar = 10; 
gamma = [1e-10,1e-5,0.001,0.005,0.01,0.05,0.1]; 
nom = max(size(gamma));  % This variable defines the number of DPS models

%-------- Now set prior means and variances (_prmean / _prvar)
theta_0_prmean = cell(nos,1);
theta_0_prvar = cell(nos,1);
Sigma_0 = cell(nos,1);
for ss=1:nos
    if prior == 1            % 1) "No dependence" prior
        for i=1:nom
            [prior_mean,prior_var] = Minn_prior_KOOP(alpha_bar,gamma(i),M(ss),p,K(ss));   
            theta_0_prmean{ss,1}(:,i) = prior_mean;
            theta_0_prvar{ss,1}(:,:,i) = prior_var;        
        end
        Sigma_0{ss,1} = cov(y_t{ss,1}(1:T0,:)); % Initialize the measurement covariance matrix (Important!)
    elseif prior == 2        % 2) Full Minnesota prior
        for i=1:nom
            [prior_mean,prior_var,sigma_var] = Minn_prior_LITT(y_t{ss,1}(1:T0,:),x_f{ss,1}(1:T0,:),alpha_bar,gamma(i),M(ss),p,K(ss),T0);   
            theta_0_prmean{ss,1}(:,i) = prior_mean;
            theta_0_prvar{ss,1}(:,:,i) = prior_var;
        end
        Sigma_0{ss,1} = sigma_var; % Initialize the measurement covariance matrix (Important!)
    end
end

%adjusting prior mean for nonstationary variables - zmenit tuhle sekci,
%zavisi na promennych zadavanych rucne na zaklade testu ADF a KPSS!!
%nezapomenout na to, ze v RC promenne 46(fhfa hpi)a 25(krippner's ssr)
%potrebuji mit prior mean 1, jsou nonstationary
vars_nonst = cell(nos,1);
vars_nonst{1,1} = [20 24]';
vars_nonst{2,1} = [20 2 51 24]';
vars_nonst{3,1} = [20 34 2 26 51 24]';
vars_nonst_pos = cell(nos,1);

for ss=1:nos
    for i=1:length(vars_nonst{ss,1})
        vars_nonst_pos{ss,1}(i,1) = find(vars{ss,1} == vars_nonst{ss,1}(i,1));
    end
end

vars_persist = cell(nos,1);
vars_persist{1,1} = [];
vars_persist{2,1} = [];
vars_persist{3,1} = [33 28 16]';
vars_persist_pos = cell(nos,1);

for ss=1:nos
    for i=1:length(vars_persist{ss,1})
        vars_persist_pos{ss,1}(i,1) = find(vars{ss,1} == vars_persist{ss,1}(i,1));
    end
end

for ss=1:nos
    for j=1:nom
        for i=1:length(vars_nonst_pos{ss,1})
            theta_0_prmean{ss,1}(vars_nonst_pos{ss,1}(i,1)*(M(ss)+1),j) = 1;
        end
    end
end

for ss=1:nos
    for j=1:nom
        for i=1:length(vars_persist_pos{ss,1})
            theta_0_prmean{ss,1}(vars_persist_pos{ss,1}(i,1)*(M(ss)+1),j) = 0.95;
        end
    end
end


%exclude training sample observations
    start_date = yearlab(T0+1);
    yearlab = yearlab(T0+1:end);
    t=t-T0;
    for ss=1:nos
        y_t{ss,1} = y_t{ss,1}(T0+1:end,:);
        x_t{ss,1} = x_t{ss,1}(T0*M(ss)+1:end,:);
    end


    
% Define forgetting factor lambda:
lambda_t = cell(nos,1);
for ss=1:nos
    if forgetting == 1
        % CASE 1: Choose the forgetting factor   

        inv_lambda = 1./lambda;
        lambda_t{ss,1}= lambda*ones(t,nom);
    elseif forgetting == 2
        % CASE 2: Use a variable (estimated) forgetting factor
        lambda_min = 0.96;
        inv_lambda = 1./0.9963;
        LL = 1.1;
        lambda_t{ss,1} = zeros(t,nom);
    else
        error('Wrong specification of forgetting procedure')
    end
end

% Initialize matrices
theta_pred = cell(nos,1);   
theta_update = cell(nos,1);
R_t = cell(nos,1);
S_t = cell(nos,1);
y_t_pred = cell(nos,1);
e_t =cell(nos,1);
A_t = cell(nos,1);
V_t = cell(nos,1);
omega_update = cell(nos,1);
omega_predict = cell(nos,1);
ksi_update = zeros(t,nos);
w_t = cell(nos,1);
w2_t = zeros(t,nos);
f_l = zeros(nom,1);
max_prob_DMS = zeros(t,1);
index_DMA = zeros(t,nos); %best gamma for each model
index_DMS = zeros(t,1); %best model out of small/medium/large
%Ptt_win = cell(t,1); %P(t|t) for a winning model in each time
sum_prob_omega = zeros(nos,1);
max_prob = cell(nos,1);
k_max = cell(nos,1);

offset = 1e-9;  % just a constant for numerical stability

%----------------------------- END OF PRELIMINARIES ---------------------------


%======================= BEGIN KALMAN FILTER ESTIMATION =======================
tic;
for irep = 1:t
    if mod(irep,ceil(t./40)) == 0
        disp([num2str(100*(irep/t)) '% completed'])
        toc;
    end
    for ss = 1:nos  % LOOP FOR 1 TO NOS VAR MODELS OF DIFFERENT DIMENSIONS
        % Find sum of probabilities for DPS
        if irep>1
            sum_prob_omega(ss,1) = sum((omega_update{ss,1}(irep-1,:)).^eta);  % this is the sum of the nom model probabilities (all in the power of the forgetting factor 'eta')
        end
        for k=1:nom % LOOP FOR 1 TO NOM VAR MODELS WITH DIFFERENT DEGREE OF SHRINKAGE
            % Predict   
            if irep==1
                theta_pred{ss,1}(:,irep,k) = theta_0_prmean{ss,1}(:,k);         
                R_t{ss,1}(:,:,k) = theta_0_prvar{ss,1}(:,:,k);           
                omega_predict{ss,1}(irep,k) = 1./nom;
            else                
                theta_pred{ss,1}(:,irep,k) = theta_update{ss,1}(:,irep-1,k);
                R_t{ss,1}(:,:,k) = (1./lambda_t{ss,1}(irep-1,k))*S_t{ss,1}(:,:,k);
                omega_predict{ss,1}(irep,k) = ((omega_update{ss,1}(irep-1,k)).^eta + offset)./(sum_prob_omega(ss,1) + offset);
            end
            xx = x_t{ss,1}((irep-1)*M(ss)+1:irep*M(ss),:);
            y_t_pred{ss,1}(:,irep,k) = xx*theta_pred{ss,1}(:,irep,k);  % this is one step ahead prediction
       
            % Prediction error
            e_t{ss,1}(:,irep,k) = y_t{ss,1}(irep,:)' - y_t_pred{ss,1}(:,irep,k);  % this is one step ahead prediction error
    
            % Update forgetting factor
            if forgetting == 2
                lambda_t{ss,1}(irep,k) = lambda_min + (1-lambda_min)*(LL^(-round(e_t{ss,1}(vars_pred_pos{ss,1},irep,k)'*e_t{ss,1}(vars_pred_pos{ss,1},irep,k))));
            end
            
            % first update V[t], see the part below equation (10)
            A_t = e_t{ss,1}(:,irep,k)*e_t{ss,1}(:,irep,k)';
            if irep==1
                V_t{ss,1}(:,:,irep,k) = kappa*Sigma_0{ss,1};
            else
                V_t{ss,1}(:,:,irep,k) = kappa*squeeze(V_t{ss,1}(:,:,irep-1,k)) + (1-kappa)*A_t;
            end
            %         if all(eig(squeeze(V_t(:,:,irep,k))) < 0)
            %             V_t(:,:,irep,k) = V_t(:,:,irep-1,k);       
            %         end

            % update theta[t] and S[t]
            Rx = R_t{ss,1}(:,:,k)*xx';
            KV = squeeze(V_t{ss,1}(:,:,irep,k)) + xx*Rx;
            KG = Rx/KV;
            theta_update{ss,1}(:,irep,k) = theta_pred{ss,1}(:,irep,k) + (KG*e_t{ss,1}(:,irep,k)); 
            S_t{ss,1}(:,:,k) = R_t{ss,1}(:,:,k) - KG*(xx*R_t{ss,1}(:,:,k));
      
            % Find predictive likelihood based on Kalman filter and update DPS weights     
            if irep==1
                variance = Sigma_0{ss,1}(vars_pred_pos{ss,1},vars_pred_pos{ss,1}) + xx(vars_pred_pos{ss,1},:)*Rx(:,vars_pred_pos{ss,1});
            else
                variance = V_t{ss,1}(vars_pred_pos{ss,1},vars_pred_pos{ss,1},irep,k) + xx(vars_pred_pos{ss,1},:)*Rx(:,vars_pred_pos{ss,1});
            end
            if find(eig(variance)>0==0) > 0
                variance = abs(diag(diag(variance)));       
            end
            ymean = y_t_pred{ss,1}(vars_pred_pos{ss,1},irep,k);        
            ytemp = y_t{ss,1}(irep,vars_pred_pos{ss,1})';
            f_l(k,1) = mvnpdfs(ytemp,ymean,variance);       
            w_t{ss,1}(:,irep,k) = omega_predict{ss,1}(irep,k)*f_l(k,1);
            
        end % End cycling through nom models with different shrinkage factors
    
        % First calculate the denominator of Equation (19) (the sum of the w's)
        sum_w_t = 0;   
        for k_2=1:nom       
            sum_w_t = sum_w_t + w_t{ss,1}(:,irep,k_2);
        end
        
        % Then calculate the DPS probabilities  
        for k_3 = 1:nom
            omega_update{ss,1}(irep,k_3) = (w_t{ss,1}(:,irep,k_3) + offset)./(sum_w_t + offset);  % this is Equation (19)
        end
        [max_prob{ss,1},k_max{ss,1}] = max(omega_update{ss,1}(irep,:));
        index_DMA(irep,ss) = k_max{ss,1};
        
        % Use predictive likelihood of best (DPS) model, and fight the weight for DMA     
        w2_t(irep,ss) = omega_predict{ss,1}(irep,k_max{ss})*f_l(k_max{ss},1);
        
    end
    
    % First calculate the denominator of Equation (19) (the sum of the w's)
    sum_w2_t = 0;
    for k_2=1:nos
        sum_w2_t = sum_w2_t + w2_t(irep,k_2);
    end
    
    % Then calculate the DPS probabilities
    for k_3 = 1:nos
        ksi_update(irep,k_3) = (w2_t(irep,k_3) + offset)./(sum_w2_t + offset);  % this is Equation (19)
    end
    
    % Find best model for DMS
    [max_prob_DMS(irep,:),ss_max] = max(ksi_update(irep,:));
    index_DMS(irep,1) = ss_max;
    %Ptt_win{irep,1} = S_t{ss_max,1}(M(ss_max)+1:end,M(ss_max)+1:end,k_max{ss_max,1}); %excluding the intercept
end

%time indices for which we want impulse responses and FEVD
time = [2006+10/12 2007+6/12 2011+7/12]'; 
time_index = zeros(size(time,1),1);

for j=1:size(time,1)
    for i=1:length(yearlab)
        if yearlab(i,1) == time(j,1);
            time_index(j,1) = i;
        end
    end
end
%variable time_index contains time indices in which we want to find out
%which model is the best model, and subsequently save Btt and Ptt from
%Kalman filter for those models, because those will be needed for
%Carter&Kohn algorithm

best_model = zeros(length(time_index),2); %best model for each time, in the first column we have either
%small/medium/large model (1,2, or 3) and in the second column, we have a corresponding gamma for that model

best_model(:,1) = index_DMS(time_index,1);
    
for i=1:length(time_index)
    best_model(i,2) = index_DMA(time_index(i,1),index_DMS(time_index(i,1)));
end
    
CK_models = unique(best_model,'rows'); %unique models needed for Carter&Kohn algorithm,
%in each row there is either small/medium/large model (1,2, or 3) as the
%first element of that row, and one of 7 values for gamma as the second
%element of that row, which together fully specify the winning model
%for those models, we need to save Btt and Ptt from Kalman filter for each
%t

Btt = cell(size(CK_models,1),1); %this will store Btt for each winning model, in each element of that cell there will be Btts for one particular model
Ptt = cell(size(CK_models,1),1); %this will store Ptt for each winning model, in each element of that cell there will be Ptts for one particular model

%extracting Btts from theta_update, theta_update stores Btts for all models
for i=1:size(CK_models,1)
    Btt{i,1} = theta_update{CK_models(i,1),1}(:,:,CK_models(i,2));
end

%doing Kalman filter again to extract Ptts for winning models, because
%there was not enough memory to store Ptts for all models

%======================= BEGIN KALMAN FILTER ESTIMATION =======================
tic;
for irep = 1:t
    if mod(irep,ceil(t./40)) == 0
        disp([num2str(100*(irep/t)) '% completed'])
        toc;
    end
    for ss = 1:nos  % LOOP FOR 1 TO NOS VAR MODELS OF DIFFERENT DIMENSIONS
        % Find sum of probabilities for DPS
        if irep>1
            sum_prob_omega(ss,1) = sum((omega_update{ss,1}(irep-1,:)).^eta);  % this is the sum of the nom model probabilities (all in the power of the forgetting factor 'eta')
        end
        for k=1:nom % LOOP FOR 1 TO NOM VAR MODELS WITH DIFFERENT DEGREE OF SHRINKAGE
            % Predict   
            if irep==1
                theta_pred{ss,1}(:,irep,k) = theta_0_prmean{ss,1}(:,k);         
                R_t{ss,1}(:,:,k) = theta_0_prvar{ss,1}(:,:,k);           
                omega_predict{ss,1}(irep,k) = 1./nom;
            else                
                theta_pred{ss,1}(:,irep,k) = theta_update{ss,1}(:,irep-1,k);
                R_t{ss,1}(:,:,k) = (1./lambda_t{ss,1}(irep-1,k))*S_t{ss,1}(:,:,k);
                omega_predict{ss,1}(irep,k) = ((omega_update{ss,1}(irep-1,k)).^eta + offset)./(sum_prob_omega(ss,1) + offset);
            end
            xx = x_t{ss,1}((irep-1)*M(ss)+1:irep*M(ss),:);
            y_t_pred{ss,1}(:,irep,k) = xx*theta_pred{ss,1}(:,irep,k);  % this is one step ahead prediction
       
            % Prediction error
            e_t{ss,1}(:,irep,k) = y_t{ss,1}(irep,:)' - y_t_pred{ss,1}(:,irep,k);  % this is one step ahead prediction error
    
            % Update forgetting factor
            if forgetting == 2
                lambda_t{ss,1}(irep,k) = lambda_min + (1-lambda_min)*(LL^(-round(e_t{ss,1}(vars_pred_pos{ss,1},irep,k)'*e_t{ss,1}(vars_pred_pos{ss,1},irep,k))));
            end
            
            % first update V[t], see the part below equation (10)
            A_t = e_t{ss,1}(:,irep,k)*e_t{ss,1}(:,irep,k)';
            if irep==1
                V_t{ss,1}(:,:,irep,k) = kappa*Sigma_0{ss,1};
            else
                V_t{ss,1}(:,:,irep,k) = kappa*squeeze(V_t{ss,1}(:,:,irep-1,k)) + (1-kappa)*A_t;
            end
            %         if all(eig(squeeze(V_t(:,:,irep,k))) < 0)
            %             V_t(:,:,irep,k) = V_t(:,:,irep-1,k);       
            %         end

            % update theta[t] and S[t]
            Rx = R_t{ss,1}(:,:,k)*xx';
            KV = squeeze(V_t{ss,1}(:,:,irep,k)) + xx*Rx;
            KG = Rx/KV;
            theta_update{ss,1}(:,irep,k) = theta_pred{ss,1}(:,irep,k) + (KG*e_t{ss,1}(:,irep,k)); 
            S_t{ss,1}(:,:,k) = R_t{ss,1}(:,:,k) - KG*(xx*R_t{ss,1}(:,:,k));
      
            % Find predictive likelihood based on Kalman filter and update DPS weights     
            if irep==1
                variance = Sigma_0{ss,1}(vars_pred_pos{ss,1},vars_pred_pos{ss,1}) + xx(vars_pred_pos{ss,1},:)*Rx(:,vars_pred_pos{ss,1});
            else
                variance = V_t{ss,1}(vars_pred_pos{ss,1},vars_pred_pos{ss,1},irep,k) + xx(vars_pred_pos{ss,1},:)*Rx(:,vars_pred_pos{ss,1});
            end
            if find(eig(variance)>0==0) > 0
                variance = abs(diag(diag(variance)));       
            end
            ymean = y_t_pred{ss,1}(vars_pred_pos{ss,1},irep,k);        
            ytemp = y_t{ss,1}(irep,vars_pred_pos{ss,1})';
            f_l(k,1) = mvnpdfs(ytemp,ymean,variance);       
            w_t{ss,1}(:,irep,k) = omega_predict{ss,1}(irep,k)*f_l(k,1);
            
        end % End cycling through nom models with different shrinkage factors
    
        % First calculate the denominator of Equation (19) (the sum of the w's)
        sum_w_t = 0;   
        for k_2=1:nom       
            sum_w_t = sum_w_t + w_t{ss,1}(:,irep,k_2);
        end
        
        % Then calculate the DPS probabilities  
        for k_3 = 1:nom
            omega_update{ss,1}(irep,k_3) = (w_t{ss,1}(:,irep,k_3) + offset)./(sum_w_t + offset);  % this is Equation (19)
        end
        [max_prob{ss,1},k_max{ss,1}] = max(omega_update{ss,1}(irep,:));
        index_DMA(irep,ss) = k_max{ss,1};
        
        % Use predictive likelihood of best (DPS) model, and fight the weight for DMA     
        w2_t(irep,ss) = omega_predict{ss,1}(irep,k_max{ss})*f_l(k_max{ss},1);
        
    end
    
    %extracting Ptts for winning models
    for i=1:size(CK_models,1)
        Ptt{i,1}(:,:,irep) = squeeze(S_t{CK_models(i,1),1}(:,:,CK_models(i,2)));
    end
    
    % First calculate the denominator of Equation (19) (the sum of the w's)
    sum_w2_t = 0;
    for k_2=1:nos
        sum_w2_t = sum_w2_t + w2_t(irep,k_2);
    end
    
    % Then calculate the DPS probabilities
    for k_3 = 1:nos
        ksi_update(irep,k_3) = (w2_t(irep,k_3) + offset)./(sum_w2_t + offset);  % this is Equation (19)
    end
    
    % Find best model for DMS
    [max_prob_DMS(irep,:),ss_max] = max(ksi_update(irep,:));
    index_DMS(irep,1) = ss_max;
    %Ptt_win{irep,1} = S_t{ss_max,1}(M(ss_max)+1:end,M(ss_max)+1:end,k_max{ss_max,1}); %excluding the intercept
end
      
%CK_models(i,1) contains a number specifying the winning's model size (1 =
%small, 2 = medium, 3 = large) and CK_models(i,2) contains the
%position of gamma in a vector gamma (out of 7) corresponding to that model

%now use Carter and Kohn algorithm to draw B from its posterior
%distribution for each particular winning model, using Btt, Ptt and lambdas
%set the number of repetitions of the Carter&Kohn algorithm = # of draws
%from the posterior of Beta
nrep = 1000;
it_print = 100;  %Print in the screen every "it_print"-th iteration

%preallocate impulse responses
nhor = 60; %impulse response horizon

imp_resp = cell(length(time),1); %this matrix will store impulse responses for each of the chosen times
for i=1:length(time)
    imp_resp{i,1} = cell(length(vars{best_model(i,1),1}),1);
    for j=1:length(vars{best_model(i,1),1})
        imp_resp{i,1}{j,1} = zeros(nrep,length(vars{best_model(i,1),1}),nhor);
    end
end

%imp_resp{i,1}{j,1} - i denotes particular time in which we are storing
%impulse responses (from 1 to length(time)), j denotes a particular
%variable of the winning model in time i (see the i-th row and 1st column
%of best_model for the winning model in time i and vars for variables in
%that model) in which the shock occurred, therefore imp_resp{i,1}{j,1} is
%nrep*M(i)*nhor object denoting impulse responses of each of the M(i)
%variables to the shock in variable j, and those impulse responses are
%captured at time i

%preallocate forecast error variance decompositions
horizon = [6 12 18 24 30 36 60]'; %forecast horizon

FEVD = cell(length(time),1); %this will store FEVD for each of the chosen times
for i=1:length(time)
    FEVD{i,1} = cell(length(vars{best_model(i,1),1}),1);
    for j=1:length(vars{best_model(i,1),1})
        FEVD{i,1}{j,1} = zeros(nrep,length(vars{best_model(i,1),1}),length(horizon));
    end
end

% FEVD{i,1}{j,1} is at time i proportion of forecast error variance of
% variable j accounted for by innovations in M_i variables

%====================================== START SAMPLING ========================================
%==============================================================================================

tic; % This is just a timer
disp('Number of iterations');

for i = 1:size(CK_models,1) %for each winning model
    %Extract Btts, Ptts and lambdas for that particular model, which will be
    %repeatedly used for drawing Betas from its posterior
    bt = Btt{i,1};
    Pt = Ptt{i,1};
    f_fact = lambda_t{CK_models(i,1),1}(:,CK_models(i,2));
    %and also get measurement error covariance matrices in all time periods
    %for i-th model which will be needed for impulse response analysis
    %its Cholesky decomposition for each t
    M_i = M(CK_models(i,1),1); %number of variables in i-th model
    Rtsd = zeros(M_i,M_i,t);
    for j=1:t
        Rtsd(:,:,j) = chol(V_t{CK_models(i,1),1}(:,:,j,CK_models(i,2)),'lower');
    end
    %for impulse response analysis, following Lutkepohl (2005)
    bigj = zeros(M_i,M_i*p);
    bigj(1:M_i,1:M_i) = eye(M_i);
    
    %sample B from its posterior irep times
    for irep = 1:nrep
        %Print iterations
        if mod(irep,it_print) == 0
            disp(irep);toc;
        end
        
        
        % -----------------------------------------------------------------------------------------
        %   Sample B from p(B|y,R,Q) (R and Q are considered to be known)
        % -----------------------------------------------------------------------------------------
        
        draw_beta
        
        % -----------------------------------------------------------------------------------------
        %   Perform impulse response analysis
        % -----------------------------------------------------------------------------------------
        
        IRA_tvp
        
        % -----------------------------------------------------------------------------------------
        %   Calculate FEVD
        % -----------------------------------------------------------------------------------------
        
        FEVD_tvp
        
        
    end
end

%Graphs
qus = [.16, .5, .84];

imp_time_XY = quantile(imp_resp{3,1}{6,1},qus);
plot(1:nhor,squeeze(imp_time_XY(:,2,:)))
title('Impulse response of house prices, time XY')
xlim([1 nhor])  

FEVD_median = cell(length(time),1); %this will store median FEVD for each of the chosen times
for i=1:length(time)
    FEVD_median{i,1} = cell(length(vars{best_model(i,1),1}),1);
    for j=1:length(vars{best_model(i,1),1})
        FEVD_median{i,1}{j,1} = squeeze(quantile(FEVD{i,1}{j,1},0.5));
    end
end



FEVD_median{4,1}{2,1}(6,:)

%Figure 1
%Shrinkage coefficients gamma over time for each TVP-VAR dimension

%Small TVP-VAR
gamma_small = zeros(t,1);

for i = 1:t
    gamma_small(i,1) = gamma(1,index_DMA(i,1));
end

%Medium TVP-VAR
gamma_medium = zeros(t,1);

for i = 1:t
    gamma_medium(i,1) = gamma(1,index_DMA(i,2));
end

%Large TVP-VAR
gamma_large = zeros(t,1);

for i = 1:t
    gamma_large(i,1) = gamma(1,index_DMA(i,3));
end

plot(yearlab,gamma_small)
%graphs done in Stata


%Figure 2
%Values of lambda_t for each TVP-VAR

%Small TVP-VAR
lambda_small = zeros(t,1);

for i = 1:t
    lambda_small(i,1) = lambda_t{1,1}(i,index_DMA(i,1));
end

    
%Medium TVP-VAR
lambda_medium = zeros(t,1);

for i = 1:t
    lambda_medium(i,1) = lambda_t{2,1}(i,index_DMA(i,2));
end


%Large TVP-VAR
lambda_large = zeros(t,1);

for i = 1:t
    lambda_large(i,1) = lambda_t{3,1}(i,index_DMA(i,3));
end

plot(yearlab,lambda_small)
%graphs done in Stata


%Figure 3
%Time-varying probabilities associated with TVP-VAR of each dimension

plot(yearlab,ksi_update(:,1)) %for the small model
hold on
plot(yearlab,ksi_update(:,2)) %for medium
hold on
plot(yearlab,ksi_update(:,3)) %for large
%graphs done in Stata










