{
    if ($0 ~ /PKGEXT='/)
    {
        print("SRCEXT='.pkg.tar'");
        pkgext_found = 1;
    }
    else if ($0 ~ /SRCEXT='/)
    {
        print("SRCEXT='.src.tar'");
        srcext_found = 1;
    }
    else
    {
        print($0)
    }
}

END{
    exit !(pkgext_found && srcext_found);
}
