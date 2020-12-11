function imP = Car2Polar (imR, M, N)
M=round(M);N=round(N);
[Mc Nc] = size(imR); 
Om = (Mc+1)/2; % co-ordinates of the center of the image
On = (Nc+1)/2;
sx = (Mc-1)/2; % scale factors
sy = (Nc-1)/2;

imP  = zeros(M, N);
axisR = 1/(M-1);
axisT = 2*pi/N;

for ri = 1:M
    for ti = 1:N
        r = (ri - 1)*axisR;
        t = (ti - 1)*axisT;
        x = r*cos(t);
        y = r*sin(t);
        xR = round(x*sx + Om);  
        yR = round(y*sy + On); 
        imP (ri, ti) = imR(xR, yR);
    end
end