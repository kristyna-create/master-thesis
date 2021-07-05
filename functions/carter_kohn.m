function [bdraw] = carter_kohn(bt,Pt,t,f_fact,offset)
% Carter and Kohn (1994), On Gibbs sampling for state space models.


% draw bdraw(T|T) ~ N(B(T|T),P(T|T))
m = size(bt,1);
bdraw = zeros(t,m);
bmean = bt(:,t); %B(T|T) is the last column of bt
bvar = squeeze(Pt(:,:,t));
bdraw(t,:) = mvnrnd(bmean,bvar,1); %bmean' + randn(1,m)*chol(bvar);

% Backward recursions
for j=1:t-1
    bf = bdraw(t-j+1,:)';
    b_tt = bt(:,t-j); %current B(t|t) from Kalman filter
    P_tt = squeeze(Pt(:,:,t-j)); %current P(t|t) from Kalman filter
    cfe = bf - b_tt;
    lambd = f_fact(t-j,1); %because in the code, lambda_t (and therefore f_fact) is lambda_t+1 in the paper
    if lambd == 1
        lambd = lambd - offset;
    end
    bmean = b_tt + lambd.*cfe;
    bvar = (1-lambd).*P_tt;
    bdraw(t-j,:) = mvnrnd(bmean,bvar,1); %bmean' + randn(1,m)*chol(bvar);
end

bdraw = bdraw';
