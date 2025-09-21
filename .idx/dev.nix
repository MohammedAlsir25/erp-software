{ pkgs, ... }: {
	channel = "stable-23.11";
	packages = [
		pkgs.flutter
	];
	idx.extensions = [
		"dart-code.flutter"
	];
}
