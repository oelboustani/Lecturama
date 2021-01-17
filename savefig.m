function savefig(plotname)
    set(gca, 'FontName', 'Arial')
    print(plotname, '-dsvg')
end