<%@ page import="uk.ac.ucl.model.DirectoryNode" %>
<%@ page import="uk.ac.ucl.model.NoteNode" %>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="css/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <title>Home</title>
        <style>
            body {
                margin: 0;
                font-family: Arial, sans-serif;
            }
            #navbar {
                transition-duration: 0.15s;
                position: absolute;
                top: 100px;
                width: 250px;
                height: calc(100vh - 100px);
                background-color: #ddd;
                border-radius: 0px 5px 5px 0px;
            }
            #fileOptions {
                display: flex;
                justify-content: space-around;
            }
            .fileOption {
                text-align: center;
                display: inline-block;
                height: 20px;
                width: 20px;
                border-radius: 5px;
                padding: 5px;
                margin: 5px;
            }
            .fileOption:hover {
                background-color: #eee;
            }
            i {
                font-size: 20px;
            }
            #closeCheckbox {
                display: none;
            }
            #closeCheckbox:checked + #navbar {
                height: 40px;
                width: 50px;
            }
            #closeCheckbox:checked + #navbar #directory {
                visibility: hidden;
                transition: visibility 0s;
            }

            #closeCheckbox:not(:checked) + #navbar #directory {
                visibility: visible;
                transition: visibility 0s 0.1s;
            }
            #closeCheckbox:checked + #navbar #fileOptions .fileOption {
                display: none;
            }
            #closeCheckbox:checked + #navbar #fileOptions #close {
                display: block;
            }
            #closeCheckbox + #navbar #fileOptions #close i::before {
                content: "\f00d"; /* FontAwesome 'x' icon */
            }
            #closeCheckbox:checked + #navbar #fileOptions #close i::before {
                content: "\f061"; /* FontAwesome 'right arrow' icon */
            }
            #directory {
                overflow: hidden;
                width: 250px;
            }
            #directory * {
                position: relative;
                left: 10px;
                list-style-type: none;
                /* Constrain width to stay within directory boundaries */
                max-width: calc(100% - 10px);
                box-sizing: border-box;
            }
            .noteNode {
                width: calc(100% - 10px);
                margin: 5px 0px;
            }
            ul {
                margin: 0;
                padding: 0;
            }
            #content {
                position: fixed;
                width: calc(100% - 450px);
                min-width: 600px;
                min-height: 100vh;
                right: 0px;
                margin: 50px 100px 100px 0px;
            }
            #noteOptions {
                width: 100%;
                height: 50px;
                display: inline-flex;
            }
            #noteOptions button {
                background-color: white;
                border-radius: 5px;
                height: 40px;
                margin: 0px 50px;
                border: 1px solid #ddd;
            }
            #noteOptions select {
                height: 40px;
                margin: 0px 50px;
                border: 1px solid #ddd;
                border-radius: 5px;
                background-color: white;
            }
            #noteOptions button:hover {
                background-color: #f9f9f9;
            }
            #noteOptions button.active {
                background-color: orange;
            }
            #backpage {
                top: 50px;
                position: absolute;
                width: 100%;
                height: 100%;
                padding: 20px;
                box-sizing: border-box;
                background-color: #f9f9f9;
                border: 1px solid #ddd;
                border-radius: 5px;
                overflow-y: auto;
            }
            #noteForm {
                display: flex;
                flex-direction: column;
            }
            #noteForm [contenteditable] {
                width: 100%;
                padding: 10px;
                margin: 10px 0;
                font-size: 16px;
                outline: none;
            }
            #noteForm .title {
                font-weight: bold;
                font-size: 32px;
                margin-bottom: 20px;
            }
            #noteForm .content {
                height: calc(100% - 60px);
            }
            .placeholder {
                color: #aaa;
            }
            .tab {
                display: inline-block;
                width: 2em; /* Adjust the width as needed */
            }
            .toggle {
                cursor: pointer;
                user-select: none;
            }
            .children {
                display: none;
            }
            .dirNode.expanded > .children {
                display: block;
            }
            .dirToggle {
                position: relative;
                cursor: pointer;
            }
            .dirToggle.active {
                padding: 3px;
                font-weight: bold;
                background-color: #eee;
            }
            [contenteditable=true]:empty:before {
                content: attr(data-placeholder);
                color: #aaa;
            }
            input[type="text"] {
                position: absolute;
                width: calc(100% - 50px);
                background-color: #eee;
                border: none;
                outline: none;
                padding: 5px;
                border-radius: 5px;
            }
            .dirToggle, .noteLink {
                /* Handle text overflow */
                overflow: hidden;
                text-overflow: ellipsis;
                max-width: calc(100% - 20px); /* Account for toggle button space */
            }
            #customContextMenu {
                position: absolute;
                display: none;
                background-color: white;
                border: 1px solid #ddd;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.2);
                padding: 5px 0;
                min-width: 120px;
                z-index: 1000;
            }

            #customContextMenu div {
                height: 20px;
                padding: 8px 15px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 14px;
                color: #333;
            }
            #customContextMenu div:hover {
                background-color: #f0f0f0;
            }

            #customContextMenu i {
                font-size: 16px;
                color: #777;
            }

            #deleteOption {
                color: #e74c3c;
            }

            #renameDirField {
                background-color: inherit;
                height: 20px;
            }

        </style>
        <script>
    document.addEventListener("DOMContentLoaded", function() {
        // Initialize UI elements
        updateDirectoryTree();

        const title = document.querySelector("#noteForm .title");
        const content = document.querySelector("#noteForm .content");
        const boldButton = document.getElementById("bold");
        const italicsButton = document.getElementById("italics");
        const fontSizeSelect = document.getElementById("fontSize");
        const imageUpload = document.getElementById("imageUpload");
        const insertImageButton = document.getElementById("insertImage");
        const saveButton = document.querySelector(".noteOption button[type='submit']");
        const titleContentInput = document.getElementById("titleContent");
        const noteContentInput = document.getElementById("noteContent");
        const directoryEl = document.getElementById('directory');
        const contextMenu = document.getElementById('customContextMenu');
        let rightClickTarget = null;

        // Text formatting buttons
        boldButton.addEventListener("click", function(event) {
            event.preventDefault();
            document.execCommand("bold");
            boldButton.classList.toggle("active");
        });

        italicsButton.addEventListener("click", function(event) {
            event.preventDefault();
            document.execCommand("italic");
            italicsButton.classList.toggle("active");
        });

        fontSizeSelect.addEventListener("change", function(event) {
            const fontSize = fontSizeSelect.value;
            document.execCommand("fontSize", false, fontSize);
        });

        // Tab key handling
        content.addEventListener("keydown", function(event) {
            if (event.key === "Tab") {
                event.preventDefault();
                document.execCommand("insertText", false, "\t");
            }
        });

        // Image upload handling
        insertImageButton.addEventListener("click", function() {
            imageUpload.click();
        });

        imageUpload.addEventListener("change", function(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const img = document.createElement("img");
                    img.src = e.target.result;
                    img.style.maxWidth = "100%";
                    const range = document.getSelection().getRangeAt(0);
                    range.insertNode(img);
                    range.setStartAfter(img);
                    range.setEndAfter(img);
                    document.getSelection().removeAllRanges();
                    document.getSelection().addRange(range);
                };
                reader.readAsDataURL(file);
            }
        });

        // Save button handling
        saveButton.addEventListener("click", function(event) {
            event.preventDefault();

            titleContentInput.value = title.innerHTML;
            noteContentInput.value = content.innerHTML;

            const formData = new FormData(document.getElementById("noteForm"));

            saveButton.textContent = "Saving...";
            saveButton.disabled = true;

            fetch('saveNote', {
                method: 'POST',
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    saveButton.textContent = "Saved";
                    setTimeout(() => {
                        saveButton.textContent = "Save Note";
                        saveButton.disabled = false;
                    }, 2000);

                    if (data.noteId) {
                        document.getElementById("noteId").value = data.noteId;
                    }

                    updateDirectoryTree();
                })
                .catch(error => {
                    saveButton.textContent = "Save Note";
                    saveButton.disabled = false;
                    console.error("Error saving note:", error);
                });
        });

        // EVENT DELEGATION FOR DIRECTORY ELEMENTS
        // Single event handler for all directory-related clicks
        document.getElementById('directory').addEventListener('click', function(event) {
            // Handle toggle clicks (expand/collapse)
            if (event.target.classList.contains('toggle')) {
                event.stopPropagation();
                const dirNode = event.target.parentElement;
                dirNode.classList.toggle('expanded');
            }
            
            // Handle directory selection clicks
            else if (event.target.classList.contains('dirToggle')) {
                const dirToggle = event.target;
                
                // Check if already active
                if (dirToggle.classList.contains('active')) {
                    dirToggle.classList.remove('active');
                    document.getElementById("activeDir").value = "";
                } else {
                    // Remove active class from all directories
                    document.querySelectorAll('.dirToggle').forEach(function(dir) {
                        dir.classList.remove('active');
                    });
                    
                    // Activate clicked directory
                    dirToggle.classList.add('active');
                    dirToggle.parentElement.classList.add('expanded');
                    document.getElementById("activeDir").value = dirToggle.id;
                }
            }
            
            // Handle note clicks
            else if (event.target.classList.contains('noteLink')) {
                event.preventDefault();
                const noteLink = event.target;
                
                fetch('serveNote?id=' + noteLink.id)
                    .then(response => response.json())
                    .then(data => {
                        document.querySelector("#noteForm .content").innerHTML = data.content;
                        document.querySelector("#noteForm .title").innerHTML = noteLink.textContent;
                        document.getElementById("noteId").value = noteLink.id;
                    })
                    .catch(error => console.error('Error loading note:', error));
            }
        });

        // EVENT DELEGATION FOR FILE OPTIONS
        document.getElementById('fileOptions').addEventListener('click', function(event) {
            // Find the clicked element or its parent with class 'fileOption'
            let fileOption = event.target;
            if (!fileOption.classList.contains('fileOption')) {
                fileOption = event.target.closest('.fileOption');
            }
            
            if (!fileOption) return;
            
            // Handle new file clicks
            if (fileOption.id === 'newFile') {
                document.querySelector("#noteForm .title").innerHTML = "";
                document.querySelector("#noteForm .content").innerHTML = "";
                document.getElementById("noteId").value = "";
            }
            
            if (fileOption.id === 'newDir') {
                if (activeDir.value == "") {
                    targetContainer = document.getElementById('directory');
                }
                else {
                    activeDirToggle = document.getElementById(activeDir.value);
                    dirNode = activeDirToggle.parentElement;
                    targetContainer = dirNode.querySelector('.children');
                }
                newElement = document.createElement('li');
                newElement.className = 'dirNode';
                newElement.innerHTML = '<span class="toggle">></span><span class="dirToggle"><input id="newDirName" type="text" placeholder="New Folder"></span><ul class="children"></ul>';
                targetContainer.appendChild(newElement);

                const inputField = newElement.querySelector('input');
                inputField.focus();

                inputField.addEventListener('keydown', function(event) {
                    if (event.key === 'Enter') {
                        event.preventDefault();

                        fetch('newDir?dirPath=' + activeDir.value + '&dirName=' + inputField.value)

                        const newDirName = inputField.value;
                        inputField.remove();
                        newElement.querySelector('.dirToggle').textContent = newDirName;
                    }
                });
            }
            
            // Handle new folder clicks, etc.
            // Add more conditions here as needed
        });

        document.getElementById('directory').addEventListener('contextmenu', function(event) {
            if (event.target.classList.contains('noteLink') || event.target.closest('.dirNode')) {
                event.preventDefault();
            }
        });

        directoryEl.addEventListener('contextmenu', function(event) {
            // Find the target element - either noteLink or dirNode
            const target = event.target.classList.contains('noteLink') 
                ? event.target 
                : event.target.closest('.dirNode');
                
            if (target) {
                event.preventDefault();

                rightClickTarget = target;
                
                // Position the menu at the cursor position
                contextMenu.style.left = event.pageX + 'px';
                contextMenu.style.top = event.pageY + 'px';
                
                if (target.classList.contains('noteLink')) {
                    document.getElementById('renameOption').style.display = 'none';
                } else {
                    document.getElementById('renameOption').style.display = 'flex';
                    dirName = target.querySelector('.dirToggle').textContent;
                    document.getElementById('renameDirField').value = dirName;
                }

                contextMenu.style.display = 'block';
            }
        });

        // Hide menu on any left-click
        document.addEventListener('click', function() {
            contextMenu.style.display = 'none';
        });

        // Handle the 'Delete' option
        document.getElementById('deleteOption').addEventListener('click', function() {
            if (!rightClickTarget) return;

            // Determine if it's a note or directory
            let endpoint, id;

            if (rightClickTarget.classList.contains('noteLink')) {
                // It's a note
                id = rightClickTarget.id;
                endpoint = 'deleteNote?id=' + id;
            } else {
                // It's a directory
                path = rightClickTarget.querySelector('.dirToggle').id;
                endpoint = 'deleteDir?dirPath=' + path;  
            }

            // Make the fetch request
            fetch(endpoint)
                .then(response => response.json())
                .then(data => {
                    updateDirectoryTree()
            })
        });

        // Handle the 'Rename' option
        document.getElementById('renameOption').addEventListener('click', function(e) {
            e.stopPropagation(); // Prevent menu from closing
            
            if (!rightClickTarget || rightClickTarget.classList.contains('noteLink')) return;
            
            // Get the directory toggle element
            const dirToggle = rightClickTarget.querySelector('.dirToggle');
            if (!dirToggle) return;
            
            // Get the current directory name
            const currentName = dirToggle.textContent.trim();
            const dirPath = dirToggle.id;
            
            // Show and position the input field
            const inputField = document.getElementById('renameDirField');
            inputField.value = currentName;
            inputField.style.display = 'block';
            inputField.focus();
            
            // Hide the text content of renameOption
            this.firstChild.textContent = '';
            this.querySelector('i').style.display = 'none';
            
            // Handle input field events
            inputField.addEventListener('keydown', function(event) {
                if (event.key === 'Enter') {
                    // Here you would handle the actual rename operation
                    // For example: fetch('renameDir?dirPath=' + dirPath + '&newName=' + inputField.value)
                    fetch('renameDir?dirPath=' + dirPath + '&newName=' + inputField.value)
                        .then(response => response.json())
                        .then(data => {
                            // Update the directory tree after renaming
                            updateDirectoryTree();
                        })
                        .catch(error => console.error('Error renaming directory:', error));
                    // Hide the input and restore the context menu
                    inputField.style.display = 'none';
                    contextMenu.style.display = 'none';
                }
            });
        });
        
    });

    // Simplified update directory tree function
    function updateDirectoryTree() {
        // Store expanded directories and active directory state before updating
        const expandedDirs = [];
        document.querySelectorAll('.dirNode.expanded').forEach(function(dir) {
            const dirToggle = dir.querySelector('.dirToggle');
            if (dirToggle && dirToggle.id) {
                expandedDirs.push(dirToggle.id);
            }
        });
        
        let activeDir = null;
        const activeDirElement = document.querySelector('.dirToggle.active');
        if (activeDirElement) {
            activeDir = activeDirElement.id;
        }
                
        // Fetch and update the directory tree
        fetch('getDirectoryTree')
            .then(response => response.text())
            .then(html => {
                document.getElementById('directory').innerHTML = html;
                
                requestAnimationFrame(() => {
                    
                    expandedDirs.forEach(function(dirPath) {
                        const dirToggle = document.getElementById(dirPath);
                        
                        if (dirToggle) {
                            const dirNode = dirToggle.closest('.dirNode');
                            if (dirNode) {
                                dirNode.classList.add('expanded');
                            }
                        }
                    });
                    
                    // Restore active directory with the same approach
                    if (activeDir) {
                        const activeDirToggle = document.getElementById(activeDir);
                        if (activeDirToggle) {
                            activeDirToggle.classList.add('active');
                            document.getElementById('activeDir').value = activeDir;
                        }
                    }
                });
            })
            .catch(error => console.error('Error updating directory tree:', error));
    }
</script>
    </head>
    <body>
        <input type="checkbox" id="closeCheckbox">
        <div id="navbar">
            <div id="fileOptions">
                <div class="fileOption" id="newFile"><i class="fa-solid fa-file"></i></div>
                <div class="fileOption" id="newDir"><i class="fa-solid fa-folder-plus"></i></div>
                <div class="fileOption"><i class="fa-solid fa-arrow-up-wide-short"></i></div>
                <div class="fileOption" id="close"><label for="closeCheckbox"><i class="fa-solid"></i></label></div>
            </div>
            <div id="directory">

            </div>
        </div>
        <div id="content">
            <div id="noteOptions">
                <div class="noteOption"><button type="submit">Save Note</button></div>
                <div class="noteOption"><button id="bold"><i class="fa-solid fa-bold"></i></button></div>
                <div class="noteOption"><button id="italics"><i class="fa-solid fa-italic"></i></button></div>
                <div class="noteOption">
                    <select id="fontSize">
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3" selected>3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                    </select>
                </div>
                <div class="noteOption">
                    <input type="file" id="imageUpload" accept="image/*" style="display: none;">
                    <button type="button" id="insertImage"><i class="fa-solid fa-image"></i></button>
                </div>

            </div>
            <div id="backpage">
                <form id="noteForm" method="post" action="saveNote">
                    <input type="hidden" name="notePath" id="activeDir">
                    <input type="hidden" name="titleContent" id="titleContent">
                    <input type="hidden" name="noteContent" id="noteContent">
                    <input type="hidden" name="noteId" id="noteId">
                    <div contenteditable="true" class="title" data-placeholder="Title"></div>
                    <div contenteditable="true" class="content" data-placeholder="Start writing..."></div>
                </form>
            </div>
        </div>

        <!-- Your custom context menu -->
        <div id="customContextMenu">
            <div id="deleteOption">Delete<i class="fa-solid fa-trash"></i></div>
            <div id="renameOption">
                Rename<i class="fa-solid fa-pen"></i>
                <input type="text" id="renameDirField" style="display: none;">
            </div>
        </div>
    </body>
</html>