# Remove existing managed repository blocks before appending their canonical
# definitions. All other options, repositories, includes, and comments remain.
/^\[(raf|extra)\][[:space:]]*$/ {
    skipping = 1
    next
}

/^\[[^]]+\][[:space:]]*$/ {
    skipping = 0
}

!skipping {
    print
}
