function recon = backprojection(projections, angles, do_filtering)
% Create a ramp filter
img_size = size(projections, 1);
ramp=linspace(0, 1, ceil(img_size)/2 + 1);
ramp=[ramp(end-1:-1:1), ramp];

% Initialize the reconstruction
recon = zeros(img_size);

switch do_filtering
    case 'none'
        filter = 1;
    case 'ramp'
        filter = ramp;
    case 'hamming_window'
        filter = ramp .* hamming(img_size)';
    case 'cosine_window'
        x = linspace(-1, 1, img_size);
        filter = ramp .* cos((x/2).*pi);
    otherwise 
        warning(['Please choose from "none", "ramp", "hamming_window",' ...
            ' "cosine_window" as do_filtering variable']);
end

% Fourier transform, filtering, FFT
for i = 1:length(angles)
    line = projections(:, i);
    % FFT and do filtering
    line = (fftshift(fft(ifftshift(line))) .* filter');
    line = fftshift(ifft(ifftshift(line)));
    
    image = repmat(line, 1, size(recon, 1));
    % Continually rotate the views
    recon = recon + imrotate(image, angles(i)+90, 'bilinear', 'crop');
end
end