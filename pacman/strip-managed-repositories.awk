# Remove existing managed repository blocks and their comments before the
# canonical definitions are appended. All other options, repositories,
# includes, and comments remain. Trailing blank lines are dropped so repeated
# runs produce an identical file.
BEGIN {
    while ((getline line < repository_file) > 0) {
        if (line ~ /^#/) {
            managed_comment[line] = 1
        }
    }
    close(repository_file)
}

($0 in managed_comment) {
    next
}

/^\[(raf|extra)\][[:space:]]*$/ {
    skipping = 1
    next
}

/^\[[^]]+\][[:space:]]*$/ {
    skipping = 0
}

skipping {
    next
}

/^[[:space:]]*$/ {
    blank_lines++
    next
}

{
    for (; blank_lines > 0; blank_lines--) {
        print ""
    }
    print
}
