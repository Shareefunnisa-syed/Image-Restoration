function [ result ] = gammaCorrection(image, a, gamma)

image = im2double(image);

result = a * (image .^ gamma);

end

