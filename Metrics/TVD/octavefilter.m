function res = octavefilter(im, resolution, octave, residual)
% Calculate octave filtered image for given octave. Resolution of image is
% including the viewing conditions and given in pixels per degree.
%
% Residual: 0 = No residual
%           1 = Low residual below given octave
%           2 = High residual above given octave
%

    IM = fftshift(fft2(im));

    % Corresponding frequencies:

    center = round(.5*(size(im)+[1 1]));
    r = zeros(size(im));
    for i = 1:size(im,1)
        for j = 1:size(im,2)
            r(i,j) = sqrt(((i-center(1))/size(im,1))^2 + ...
                          ((j - center(2))/ size(im,2))^2);
        end
    end
    r = r*resolution;
    
    % Calculate octave and residual filters:
    filt = zeros(size(im));

    if residual == 0                    % Octave filter
        fcent = 2.^octave;
        ind = find(r > fcent*.5 & r < fcent*2);
        filt(ind) = .5*(1 + cos(pi*log2(r(ind))-pi*octave));

    elseif residual == 1                % Low residual
        fcent = 2.^(octave - 1);
        ind = find(r > fcent*.5 & r < fcent*2);
        filt(ind) = .5*(1 + cos(pi*log2(r(ind))-pi*(octave-1)));
        filt(find(r <= fcent)) = 1;

    elseif residual == 2                % High residual
        fcent = 2.^(octave + 1);
        ind = find(r > fcent*.5 & r < fcent*2);
        filt(ind) = .5*(1 + cos(pi*log2(r(ind))-pi*(octave+1)));
        filt(find(r >= fcent)) = 1;

    end

    % Perform filtering
    res = ifft2(ifftshift(IM.*filt));
