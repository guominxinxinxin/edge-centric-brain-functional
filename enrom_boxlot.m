enorm5 = load("enorm_nc"); 
enorm6 = load("enrom_sa"); 
figure, 
boxplot({enorm5, enorm6},lab,'Labels', net,'LabelOrientation', 'inline');


title('Comparison of Normalized Entropy between Two Systems')