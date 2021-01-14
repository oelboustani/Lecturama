clc
close all
clear all

ArraySize = 64;
X = randi([0 1], [ArraySize 1]);
PSK = pskmod(X, ArraySize);
scatterplot(PSK)
