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

    ynh_replace_string --target_file="$install_dir/sources/src/data/main.yml" \
        --match_string="framanav: true" \
        --replace_string="framanav: false"

    # %/ is here to prevent double slash
    ynh_replace_string --target_file="$install_dir/sources/config/env.js" \
        --match_string=": '${old_path:-}/'," \
        --replace_string=": '${path%/}/',"
}

_build_install_framagames() {
    pushd "$install_dir/sources"
        ynh_use_nodejs
        ynh_exec_warn_less ynh_exec_as "$app" env "$ynh_node_load_PATH" "$ynh_npm" run commons
        ynh_exec_warn_less ynh_exec_as "$app" env "$ynh_node_load_PATH" "$ynh_npm" run prod
    popd

    ynh_secure_remove --file="$install_dir/www"
    mv -f "$install_dir/sources/dist" "$install_dir/www"
    cp -r "$install_dir/sources/games/"* "$install_dir/www"
    if [[ "$path" != "/" ]]; then
        mv -f "$install_dir/www/$path/"* "$install_dir/www"
    fi
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

#=================================================
# FUTURE OFFICIAL HELPERS
#=================================================
