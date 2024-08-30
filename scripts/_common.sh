#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

nodejs_version=12

_configure_framagames() {
    ynh_replace --file="$install_dir/sources/src/data/main.yml" \
        --match="canonical: .*" \
        --replace="canonical: https://$domain$path"

    ynh_replace --file="$install_dir/sources/src/data/main.yml" \
        --match="framanav: true" \
        --replace="framanav: false"

    # %/ is here to prevent double slash when path is /
    ynh_replace --file="$install_dir/sources/config/env.js" \
        --match="  basepath:.*" \
        --replace="  basepath: '${path%/}/', wrong_path: false"
}

_build_install_framagames() {
    pushd "$install_dir/sources"

        ynh_hide_warnings ynh_exec_as_app node_load_PATH" npm run commons
        ynh_hide_warnings ynh_exec_as_app node_load_PATH" npm run prod
    popd

    ynh_safe_rm "$install_dir/www"
    mv -f "$install_dir/sources/dist" "$install_dir/www"
    cp -r "$install_dir/sources/games/"* "$install_dir/www"
    if [[ "$path" != "/" ]]; then
        mv -f "$install_dir/www/$path/"* "$install_dir/www"
    fi
    #REMOVEME? Assuming the install dir is setup using ynh_setup_source, the proper chmod/chowns are now already applied and it shouldn't be necessary to tweak perms | chown -R "$app:www-data" "$install_dir"
}
