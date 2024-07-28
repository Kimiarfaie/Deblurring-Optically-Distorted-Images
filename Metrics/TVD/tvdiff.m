function d = tvdiff(im1, im2, lambda, p, TVopt)
    diffim = im1 - im2;
    nx = size(diffim,1);
    ny = size(diffim,2);
    nc = size(diffim,3);
    TV =  zeros(1, nc);

    % TV term:
    for i = 1:nc
        ch = diffim(:,:,i);
        [Dx, Dy] = gradient(ch);
        tmp = sqrt(Dx.*Dx + Dy.*Dy);
        tmp(isnan(tmp)) = 0;
        tmp = sum(tmp(:));
        TV(i) = tmp;
    end
    
    %TV or Color TV
    if(TVopt == 1)
        TV = norm(TV,1); %L1 Norm
    elseif(TVopt ==2)
        TV = norm(TV,2); %L2 Norm
    end
    
    % Fidelity term
    coldiff2 = sqrt(sum(diffim.^2,3)); %color difference
    coldiff2(isnan(coldiff2)) = 0;

    %L1 or L2 Norm
    if p == 1
        %fidelity = sum(coldiff2(:)); %L1 Norm
        fidelity = norm(coldiff2(:),1); %L1 Norm
    elseif p == 2
        fidelity = sum(coldiff2(:).^2); %L2 norm
        %fidelity = norm(coldiff2(:),2); %L2 Norm
    end

    %Normalizing
    TV = TV/(nx*ny);
    fidelity = fidelity/(nx*ny);
    
    %Total Difference
    %disp(sprintf('\t\t\tTV:\t%f, Fidelity:\t%f', TV, fidelity));
    d = TV + lambda*fidelity;