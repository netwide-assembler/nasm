#!/usr/bin/perl
%packed_insns = (
    'vfmadd'    => 0x98,
    'vfmaddsub' => 0x96,
    'vfmsubadd' => 0x97,
    'vfmsub'    => 0x9a,
    'vfnmadd'   => 0x9c,
    'vfnmsub'   => 0x9e
    );

%scalar_insns = (
    'vfmadd'    => 0x99,
    'vfmsub'    => 0x9b,
    'vfmnadd'   => 0x9c,
    'vfmnsub'   => 0x9f
    );

foreach $pi ( sort(keys(%packed_insns)) ) {
    $op = $packed_insns{$pi};
    foreach $order ('132', '213', '231') {
	$xorder = substr($order,1,1).substr($order,0,1).substr($order,2,1);
	foreach $o ($order, $xorder) {
	    for ($w = 0; $w < 2; $w++) {
		$suf = $w ? 'pd' : 'ps';
		$mm  = $w ? 'ymm' : 'xmm';
		$sx  = $w ? 'SY' : 'SO';
		$ww  = $w ? 256 : 128;
		printf "%-15s %-31s %-47s %s\n",
		"\U${pi}${o}${suf}",
		"${mm}reg,${mm}reg,${mm}rm",
		sprintf("[rvm:\tvex.dds.%d.66.0f38.w%d %02x /r]",
			$ww, $w, $op),
		"FMA,SANDYBRIDGE,${sx}";
		printf "%-15s %-31s %-47s %s\n",
		"\U${pi}${o}${suf}",
		"${mm}reg,${mm}rm",
		sprintf("[r+vm:\tvex.dds.%d.66.0f38.w%d %02x /r]",
			$ww, $w, $op),
		"FMA,SANDYBRIDGE,${sx}";
	    }
	}
	$op++;
    }
}

foreach $si ( sort(keys(%scalar_insns)) ) {
    $op = $scalar_insns{$si};
    foreach $order ('132', '213', '231') {
	$xorder = substr($order,1,1).substr($order,0,1).substr($order,2,1);
	foreach $o ($order, $xorder) {
	    for ($w = 0; $w < 2; $w++) {
		$suf = $w ? 'sd' : 'ss';
		$mm  = 'xmm';
		$sx  = $w ? 'SQ' : 'SD';
		$ww  = 128;
		printf "%-15s %-31s %-47s %s\n",
		"\U${si}${o}${suf}",
		"${mm}reg,${mm}reg,${mm}rm",
		sprintf("[rvm:\tvex.dds.%d.66.0f38.w%d %02x /r]",
			$ww, $w, $op),
		"FMA,SANDYBRIDGE,${sx}";
		printf "%-15s %-31s %-47s %s\n",
		"\U${si}${o}${suf}",
		"${mm}reg,${mm}rm",
		sprintf("[r+vm:\tvex.dds.%d.66.0f38.w%d %02x /r]",
			$ww, $w, $op),
		"FMA,SANDYBRIDGE,${sx}";
	    }
	}
	$op++;
    }
}
