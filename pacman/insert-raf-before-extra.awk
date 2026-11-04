# Replace an existing raf block and insert its canonical definition immediately
# before Arch's existing extra repository without reordering official repos.
# Comment lines from repository_file are treated as managed and removed from
# their old position so repeated runs produce an identical file.
BEGIN {
    while ((getline line < repository_file) > 0) {
        if (line ~ /^#/) {
            managed_comment[line] = 1
        }
    }
    close(repository_file)
}

function print_repository(    line) {
    while ((getline line < repository_file) > 0) {
        print line
    }
    close(repository_file)
    print ""
    inserted = 1
}

($0 in managed_comment) {
    next
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
