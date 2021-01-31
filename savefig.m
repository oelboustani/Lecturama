function savefig(plotname)
    set(gca, 'FontName', 'Arial')
    plotname = ['figures/',plotname];
    print(plotname, '-dsvg')
end