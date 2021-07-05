            % Impulse response analysis.
            % Set up things in VAR(1) format as in Lutkepohl (2005) page 51
            biga = zeros(M_i*p,M_i*p);
            for j = 1:p-1
                biga(j*M_i+1:M_i*(j+1),M_i*(j-1)+1:j*M_i) = eye(M_i);
            end

            for x = 1:t %Get impulses recursively for each time period
                bbtemp = Btdraw(M_i+1:end,x);  % get the draw of B(t) at time x=1,...,T  (exclude intercept)
                splace = 0;
                for ii = 1:p
                    for iii = 1:M_i
                        biga(iii,(ii-1)*M_i+1:ii*M_i) = bbtemp(splace+1:splace+M_i,1)';
                        splace = splace + M_i;
                    end
                end
           

                % ------------Identification code:                
                % St dev matrix for structural VAR
                Rsd = squeeze(Rtsd(:,:,x));   % First shock is the Cholesky of the VAR covariance
                diagonal = diag(diag(Rsd));
                Rsd = Rsd*inv(diagonal);    % Rescale to get unit initial shock
                %also make irate_shock unit shock to policy rate
                shocks_mat = eye(M_i);
                shocks_mat(vars{CK_models(i,1),1} == irate_pos,vars{CK_models(i,1),1} == irate_pos) = irate_shock; 
                %the key interest in the model has position irate_pos among
                %variables
                Rsd = Rsd*shocks_mat; %scaling to get the response of variables to irate_shock unit shock to policy rate
                
                % Now get impulse responses for 1 through nhor future periods
                impresp = zeros(M_i,M_i*nhor);
                
                %Rescale to convert to responses of non-standardized variables
                vect = st_dev(vars{CK_models(i,1),1},1);
                scale_mat = zeros(M_i);
                for h=1:M_i
                    for g=1:M_i
                        scale_mat(h,g) = vect(h,1)/vect(g,1);
                    end
                end
                impresp(1:M_i,1:M_i) = Rsd.*scale_mat; % First shock is the Cholesky of the VAR covariance, but scaled

                bigai = biga;
                for j = 1:nhor-1
                    impresp(:,j*M_i+1:(j+1)*M_i) = bigj*bigai*bigj'*Rsd.*scale_mat;
                    bigai = bigai*biga;
                end

                % Only for specified periods
                for v = 1:length(time_index);
                    if x == time_index(v,1) && best_model(v,1) == CK_models(i,1) && best_model(v,2) == CK_models(i,2)
                        for jj = 1:M_i
                            for ij = 1:nhor
                                imp_resp{v,1}{jj,1}(irep,:,ij) = impresp(:,jj+(ij-1)*M_i); %store draws of responses
                            end
                % Now calculate accumulated impulse responses to a policy rate shock (variable with number irate_pos)
                % if the responding variables are in log-differences (tcode=5) to get percentage effect
                            if jj == find(vars{CK_models(i,1),1} == irate_pos)
                                acc_resp = 0;
                                for ij = 1:nhor
                                    imp_resp{v,1}{jj,1}(irep,tcode(vars{CK_models(i,1),1},1) == 5,ij) = ...
                                        impresp(tcode(vars{CK_models(i,1),1},1) == 5,jj+(ij-1)*M_i) + acc_resp;
                                    acc_resp = acc_resp + impresp(tcode(vars{CK_models(i,1),1},1) == 5,jj+(ij-1)*M_i);
                                end
                            end
                                 
                        end
                    end
                end
                
             
            end %END getting impulses for each time period