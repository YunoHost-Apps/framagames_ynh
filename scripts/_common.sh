#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

nodejs_version=12

#=================================================
# PERSONAL HELPERS
#=================================================

_configure_framagames() {
    ynh_replace_string --target_file="$install_dir/sources/src/data/main.yml" \
        --match_string="canonical: .*" \
        --replace_string="canonical: https://$domain$path"

    ynh_replace_string --target_file="$install_dir/sources/config/env.js" \
        --match_string=": '/'," \
        --replace_string=": '$path/',"
}

_build_install_framagames() {
    pushd "$install_dir/sources"
        ynh_use_nodejs
        ynh_exec_warn_less ynh_exec_as "$app" env "$ynh_node_load_PATH" "$ynh_npm" run commons
        ynh_exec_warn_less ynh_exec_as "$app" env "$ynh_node_load_PATH" "$ynh_npm" run prod
    popd

    mv -f "$install_dir/sources/dist" "$install_dir/www"
    mv -f "$install_dir/sources/games/"* "$install_dir/www"
    cp "$install_dir/www/fr/index.html" "$install_dir/www/index.html"
    # cd public && for f in $(find -type l);do cp --remove-destination $(readlink -f $f) $f;done;
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
