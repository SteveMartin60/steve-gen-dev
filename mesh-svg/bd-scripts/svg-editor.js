//..............................................................................

var diagram;
var editor;
var elementsAll;
var elementsDiagram;
var elementsEditor;
var diagramIDString = 'block-diagram';
var editorIDString  = 'editor-tools';
var coordinates;
var buttons;
var diagramBackground;
var crosshairsBlue;
var highlightRect;
var components;
var diagrams;
var thumb;

var dimensions = {};
var elementID;
var j;
//..............................................................................

//..............................................................................
function getSubDocument(embedding_element)
{
    if (embedding_element.contentDocument)
    {
        return embedding_element.contentDocument;
    }
    else
    {
        var subdoc = null;

        try
        {
            subdoc = embedding_element.getSVGDocument();
        }
        catch(e) {}

        return subdoc;
    }
}
//..............................................................................

//..............................................................................
function findEditorSVGElements()
{
    var svgObjects = document.querySelectorAll(".emb");
    var image;
    var caption;

    var allElements = document.querySelectorAll("*");

    console.log('allElements.length: ' + allElements.length);

    for (var i = 0; i < allElements.length; i++)
    {
        var element = allElements[i];

        //if (element.getAttribute('class'))
        //if (element.properties)
        {
            console.log('==============================');
            console.log('Element   :  ' + element);
            //console.log('Type   :  ' + element.properties.Type);
            //console.log('type   :  ' + element.properties.type);
            //console.log('innerHTML :  ' + element.innerHTML);
            console.log('ID        :  ' + element.getAttribute('id'));
            console.log('Class     :  ' + element.getAttribute('class'));
            //console.log('Element Str: ' + getElementString(element));
            console.log('------------------------------');
            console.log('');
        }
    }


    components = document.getElementsByClassName("component");
    diagrams   = document.getElementsByClassName("diagram");
    thumb      = document.getElementById("block-diagram-thumb");

    if (thumb)
    {
        console.log('Image Source: ' + thumb.src);
    }

    for (i = 0; i < diagrams.length; i++)
    {
        var diagram = diagrams[i];

        diagram.addEventListener('click'    , onClick  );

        image     = diagram.getElementsByTagName('img')[0];
        caption   = diagram.getElementsByTagName('alt')[0];

/*
        console.log('innerHTML   : ' + diagram.innerHTML);
        console.log('Image Source: ' + image.src);
        console.log('Caption     : ' + image.alt);
*/
    }

    for ( i = 0; i < components.length; i++)
    {
        var component = components[i];
        image     = component.getElementsByTagName('img')[0];
        caption   = component.getElementsByTagName('alt')[0];

        component.addEventListener('click'    , onClick  );

/*
        console.log('innerHTML   : ' + component.innerHTML);
        console.log('Image Source: ' + image.src);
        console.log('Caption     : ' + image.alt);
*/
    }

    for (i = 0; i < svgObjects.length; i++)
    {
        var subDoc = getSubDocument(svgObjects[i]);

        console.log("svgObjects: " + svgObjects[i]);
        
        if (subDoc)
        {

            elementsAll  = subDoc.querySelectorAll('*');

            var root = subDoc.getElementsByTagName('svg')[0];

            addEventListeners();

            if (root.getAttribute('id') === diagramIDString)
            {

                console.log('Found Diagram');
                diagram = root;

                elementsDiagram = diagram.querySelectorAll('*');

                for (i = 0; i < elementsDiagram.length; i++)
                {

                    elementsDiagram[i].setAttribute('cursor', 'default' );
                }
            }

            if (root.getAttribute('id') === editorIDString)
            {
                console.log('Found Editor');

                editor = root;

                elementsEditor = editor.querySelectorAll('*');

                coordinates         = editor.getElementById('coordinates'        );
                buttons             = editor.getElementById('buttons'            );
                diagramBackground   = editor.getElementById('diagramBackground'  );
                crosshairsBlue      = editor.getElementById('crosshairs-blue'    );

                highlightRect    = editor.getElementById('highlight-rect');

                console.log(highlightRect);

                for (i = 0; i < elementsEditor.length; i++)
                {
                    elementsEditor[i].setAttribute('cursor', 'default' );
                }
            }
        }
    }
}
//..............................................................................

//..............................................................................
function getElementBounds(element)
{
    var domRectPointTL  = diagram.createSVGPoint();
    var domRectPointBR  = diagram.createSVGPoint();

    var elementBounds = {};

    var domRect = element.getBoundingClientRect();

    domRectPointTL.x = domRect.left;
    domRectPointTL.y = domRect.top;
    domRectPointBR.x = domRect.right;
    domRectPointBR.y = domRect.bottom;

    domRectPointTL = domRectPointTL.matrixTransform(diagram.getScreenCTM().inverse());
    domRectPointBR = domRectPointBR.matrixTransform(diagram.getScreenCTM().inverse());

    elementBounds.top    = domRectPointTL.y;
    elementBounds.left   = domRectPointTL.x;
    elementBounds.bottom = domRectPointBR.y;
    elementBounds.right  = domRectPointBR.x;

    return elementBounds;
}
//..............................................................................

//..............................................................................
function highlightOnMouseOver(element)
{
    var elementID     = element.getAttribute('id');

    if (elementID === null) return false;
    if (elementID === null) return false;

    return elementID.indexOf('component') > -1 || elementID.indexOf('f-block')> -1;
}
//..............................................................................

//..............................................................................
function mouseMove(evt)
{
    var mouseCoords   = diagram.createSVGPoint();

    var element       = evt.target;
    var elementBounds = getElementBounds(element);

    if (highlightOnMouseOver(element))
    {
        element.setAttribute('transform', 'scale(1.01)');
        element.setAttribute('opacity', '0.95');
    }

    mouseCoords .x = evt.clientX;
    mouseCoords .y = evt.clientY;

    mouseCoords = mouseCoords.matrixTransform(diagram.getScreenCTM().inverse());

    mouseCoords .x = Math.round(mouseCoords .x);
    mouseCoords .y = Math.round(mouseCoords .y);

    elementID      = element.getAttribute("id");

    elementCaption = element.getAttribute("caption") || elementID;

    if (elementID)
    {
    }
}
//..............................................................................

//..............................................................................
function mouseOut(evt)
{
    var element = evt.target;

    if (highlightOnMouseOver(element))
    {
        element.setAttribute('transform', 'scale(1)');
    }

}
//..............................................................................

//..............................................................................
function onClick(evt)
{
    var element = evt.target;

    thumb      = document.getElementsByTagName("svg");

    console.log('Clicked: ' + document.parentNode);

    // location.reload();
}
//..............................................................................

//..............................................................................
function refreshDoc()
{
    location.reload();
}
//..............................................................................

//..............................................................................
function getElementString(element)
{
    var serializer = new XMLSerializer();

    return serializer.serializeToString(element);
}
//..............................................................................

//..............................................................................
function refreshClick(evt)
{
    // console.log('here2');
    // location.reload();
}
//..............................................................................

//..............................................................................
function onResize(evt)
{
    console.log('Resizing!');
}
//..............................................................................

//..............................................................................
function addEventListeners()
{
    var elementID = '';

    for (var i = 0; i < elementsAll.length; i++)
    {
        elementID = elementsAll[i].getAttribute('id') || 'NoID';

        elementsAll[i].addEventListener('click'    , onClick  );
        elementsAll[i].addEventListener('mousemove', mouseMove);
        elementsAll[i].addEventListener('mouseout' , mouseOut );
        elementsAll[i].addEventListener('resize'   , onResize);

        //if (elementID.indexOf('component') !== -1)
        {
/*
            console.log('==============================');
            console.log('Adding: ' + elementsAll[i].getAttribute('id'));
            console.log('Element Str: ' + getElementString(elementsAll[i]));
            console.log('------------------------------');
            console.log('');
*/

        }
    }

}
//..............................................................................

//..............................................................................
