function getElementByIdCompatible(id) {
	if(document.getElementById) {
		return document.getElementById(id);
	} else if (document.all) {
		return document.all[id];
	} else if (document.layers) {
		return document.layers[id];
	}

	return null;
}

function hideMenu() {
	var menu = getElementByIdCompatible("menu");
	if(menu == null) {
		return;
	}

	menu.style.display = "none";
}

function toggleMenu() {
	var menu = getElementByIdCompatible("menu");
	if(menu == null) {
		return;
	}

	var display = menu.style.display;
	if("none" == display) {
		menu.style.display = "block";
	} else {
		menu.style.display = "none";
	}
}
