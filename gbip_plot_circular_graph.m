function gbip_plot_circular_graph(cm,roilabel)

% gbip_circular_graph(cm,roilable)
% roilable is a cell includes roi names
% red=positive, blue=negative
% need circular graph toolbox

% scale the values based all values
% [a,b,v] = find(cm);
% sv = v./max(abs(v));
% scaledmat = zeros(size(cm));
% for i = 1 : length(a)
%     scaledmat(a(i),b(i)) = sv(i);
% end

positivemat = zeros(size(cm));
negativemat = zeros(size(cm));
positivemat(cm>0) = cm(cm>0);
negativemat(cm<0) = cm(cm<0);

myColorMap = repmat([1 0 0],length(cm),1);
circularGraph(positivemat,'Colormap',myColorMap,'Label',roilabel);
hold on,
myColorMap = repmat([0 0 1],length(cm),1);
circularGraph(negativemat,'Colormap',myColorMap,'Label',roilabel);