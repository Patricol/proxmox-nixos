{
  lib,
  stdenv,
  fetchgit,
  perl536,
  proxmox-widget-toolkit,
  asciidoc,
  librsvg,
}:

let
  perlDeps = with perl536.pkgs; [ JSON ];

  perlEnv = perl536.withPackages (_: perlDeps);
in

stdenv.mkDerivation rec {
  pname = "pve-docs";
  version = "8.2.5";

  src = fetchgit {
    url = "git://git.proxmox.com/git/${pname}.git";
    rev = "3734b4f879125c2b3fe64eebc92a17a1e594c262";
    hash = "sha256-No3qtUK8ZAuAQUqhS1t5M7dMBP/+og+aNXpRRoBSWmU=";
  };

  postPatch = ''
    patchShebangs scan-adoc-refs
    sed -i Makefile \
      -e '/GITVERSION/d' \
      -e '/pkg-info/d' \
      -e "s|/usr/share/javascript/proxmox-widget-toolkit-dev|${proxmox-widget-toolkit}/share/javascript/proxmox-widget-toolkit|" \
      -e 's|/usr||' \
      -e "s/gen-install doc-install mediawiki-install/gen-install mediawiki-install/" \
      -e 's|\./asciidoc-pve|$out/bin/asciidoc-pve|'
    #find . -type f | xargs sed -i -e "s|/usr|$out|"
  '';

  buildInputs = [
    asciidoc
    librsvg
    perlEnv
  ];
  propagatedBuildInputs = perlDeps;

  makeFlags = [
    "GITVERSION=${src.rev}"
    "INDEX_INCLUDES="
    "DESTDIR=$(out)"
  ];

  passthru.updateScript = [
    ../update.py
    pname
    "--url"
    src.url
  ];

  meta = with lib; {
    description = "Proxmox VE Documentation";
    homepage = "git://git.proxmox.com/?p=pve-docs.git";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      camillemndn
      julienmalka
    ];
    platforms = platforms.linux;
  };
}
