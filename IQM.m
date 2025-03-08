function iqm = IQM(image, c1, c2, c3)

if ~exist('c1', 'var')
    c1 = 0.0282;
end

if ~exist('c2', 'var')
    c2 = 0.2953;
end

if ~exist('c3', 'var')
    c3 = 3.5753;
end

icm = ICM(image);
ism = ISM(image);
iconm = IConM(image);

iqm = c1 * icm + c2 * ism + c3 * iconm;

end
