function [ protocol ] = Scheme2noddi_StejskalTanner( scheme )

protocol = [];
protocol.pulseseq = 'PGSE';
protocol.schemetype = 'multishellfixedG';
protocol.teststrategy = 'fixed';

% load bval
bval = scheme.b;

% set total number of measurements
protocol.totalmeas = length(bval);

% set the b=0 indices
protocol.b0_Indices = find(bval==0);
protocol.numZeros = length(protocol.b0_Indices);

% find the unique non-zero b-values
B = unique(bval(bval>0));

% set the number of shells
protocol.M = length(B);
for i=1:length(B)
    protocol.N(i) = length(find(bval==B(i)));
end

for i = 1:length(B)
    protocol.udelta(i)    = scheme.shells{i}.Delta;
    protocol.usmalldel(i) = scheme.shells{i}.delta;
    protocol.uG(i)        = scheme.shells{i}.G;
end

protocol.delta    = zeros(size(bval))';
protocol.smalldel = zeros(size(bval))';
protocol.G        = zeros(size(bval))';

for i=1:length(B)
    tmp = find(bval==B(i));
    for j=1:length(tmp)
        protocol.delta(tmp(j)) = protocol.udelta(i);
        protocol.smalldel(tmp(j)) = protocol.usmalldel(i);
        protocol.G(tmp(j)) = protocol.uG(i);
    end
end

% load bvec
protocol.grad_dirs = scheme.camino(:,1:3);

% make the gradient directions for b=0's [1 0 0]
for i=1:length(protocol.b0_Indices)
    protocol.grad_dirs(protocol.b0_Indices(i),:) = [1 0 0];
end

% make sure the gradient directions are unit vectors
for i=1:protocol.totalmeas
    protocol.grad_dirs(i,:) = protocol.grad_dirs(i,:)/norm(protocol.grad_dirs(i,:));
end
end