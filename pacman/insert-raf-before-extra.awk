# Replace an existing raf block and insert its canonical definition immediately
# before Arch's existing extra repository without reordering official repos.
function print_repository(    line) {
    while ((getline line < repository_file) > 0) {
        print line
    }
    close(repository_file)
    print ""
    inserted = 1
}

/^\[raf\][[:space:]]*$/ {
    skipping = 1
    next
}

/^\[[^]]+\][[:space:]]*$/ {
    skipping = 0
    if ($0 == "[extra]" && !inserted) {
        print_repository()
    }
}

!skipping {
    print
}

END {
    if (!inserted) {
        print ""
        print_repository()
    }
}
