draw = 0;

while draw == 0  %drawing coefficients until the draw is kept
    
  %Btdrawc is a draw of the mean VAR coefficients, B(t)
    [Btdrawc] = carter_kohn(bt,Pt,t,f_fact,offset);
    
    %Accept draw
%      Btdraw = Btdrawc;
%      draw = 1;
    %or use the code below to check for stationarity
    %Now check for the polynomial roots to see if explosive
    %only times for which we want the impulse responses
    ctemp1 = zeros(M_i*p,M_i*p);
    
    for j = 1:p-1
        ctemp1(j*M_i+1:M_i*(j+1),M_i*(j-1)+1:j*M_i) = eye(M_i);
    end
    
    counter = [];
    restviol = 0;
    
    for k = 1:t;
        for v = 1:length(time_index)
            if k == time_index(v,1) && best_model(v,1) == CK_models(i,1) && best_model(v,2) == CK_models(i,2)
                BBtempor = Btdrawc(M_i+1:end,k); %excluding the intercept
                splace = 0;
                
                for ii = 1:p
                    for iii = 1:M_i
                        ctemp1(iii,(ii-1)*M_i+1:ii*M_i) = BBtempor(splace+1:splace+M_i,1)';
                        splace = splace + M_i;
                    end
                end
                
                if max(abs(eig(ctemp1))) >= 1; %in this case, VAR is not stable
                    restviol = 1;
                    counter = [counter ; restviol];
                end
            end
        end
    end
    
    
    if sum(counter) == 0
        Btdraw = Btdrawc;
        draw = 1;
    else
        draw = 0;
    end
    
end

                
                
                
                
                
             