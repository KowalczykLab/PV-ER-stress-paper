/*
 * Objective: Merge two channels which may or may not be in the same folder
 * 
 * CH1's suffix is C1-
 * CH2's suffix is C2- 
 * 
 * Assume nothing else is in the folder but split CH images
 */

#@ boolean (label = "CH2 in different dir from CH1") CH2_in_diff_dir_than_CH1
#@ File (label = "Input CH1 directory", style = "directory") input_CH1
#@ File (label = "Input CH2 directory", style = "directory") input_CH2
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

// See also Process_Folder.py for a version of this code
// in the Python scripting language.

if (CH2_in_diff_dir_than_CH1) {
	list_CH1 = getFileList(input_CH1);
	list_CH1 = Array.sort(list_CH1);

	list_CH2 = getFileList(input_CH2);
	list_CH2 = Array.sort(list_CH2);

	for (i = 0; i < list_CH1.length; i++) {
		CH1_file = list_CH1[i];
		CH2_file = list_CH2[i];

		open(input_CH1 + File.separator + CH1_file);
		open(input_CH2 + File.separator + CH2_file);

		run("Merge Channels...", "c1=[" + CH1_file + "] c2=[" + CH2_file + "] keep ignore");
		Stack.setChannel(1);
		run("BOP orange ");
		Stack.setChannel(2);
		run("BOP blue ");
		merged_name = substring(CH1_file,3);
		saveAs("tiff", output + File.separator + merged_name);
		run("Close All");
	}
}
else { // CH1 and CH2 are in the same dir
	
}
list_CH1 = getFileList(input_CH1);
list_CH1 = Array.sort(list_CH1);


//processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix

function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// Leave the print statements until things work, then remove them.
	print("Processing: " + input + File.separator + file);
	print("Saving to: " + output);
}
