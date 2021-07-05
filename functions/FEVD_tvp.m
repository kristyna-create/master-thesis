%Calculates FEVD for all IRF matrices in a given time
%uses imp_resp{t,1}{k,1}(irep,j,hh) - impulse responses of variable j to the
%shock in variable k using Beta coefficients from time t: for each irep
%(draw from the posterior of Beta), IRFs are calculated for hh impulse
%response horizons
for x = 1:t
    for v = 1:length(time_index)
        if x == time_index(v,1) && best_model(v,1) == CK_models(i,1) && best_model(v,2) == CK_models(i,2)
            for j = 1:M_i
                for k_fix = 1:M_i
                    for hh = 1:length(horizon)
                        nominator = 0;
                        denominator = 0;
                        for q = 1:horizon(hh)
                            nominator = nominator + (imp_resp{v,1}{k_fix,1}(irep,j,q))^2;
                            for k = 1:M_i
                                denominator = denominator + (imp_resp{v,1}{k,1}(irep,j,q))^2;
                            end
                        end
                        FEVD{v,1}{j,1}(irep,k_fix,hh) = nominator/denominator;
                    end
                end
            end
        end
    end
end

                        
                        
                        
    
