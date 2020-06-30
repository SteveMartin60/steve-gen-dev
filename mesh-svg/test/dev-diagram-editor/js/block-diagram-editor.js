//..............................................................................

var diagram;
var editor;
var elementsAll;
var elementsDiagram;
var elementsEditor;
var elementsTooltip;
var elementsGridTarget;
var diagramIDString = 'block-diagram';
var editorIDString  = 'editor-tools';
var tooltipIDString = 'tooltip';
var coordinates;
var elementX         ;
var elementY         ;
var infoBox          ;
var dimensionsBox    ;
var buttons          ;
var diagramBackground;
var crosshairsBlue   ;
var gridTarget      ;
var highlightRect;

var elementInfoCap     ;
var elementInfoX       ;
var elementInfoY       ;
var elementInfoLeft    ;
var elementInfoRight   ;
var elementInfoTop     ;
var elementInfoBottom  ;
var elementInfoWidth   ;
var elementInfoHeight  ;

var dimensionInfoLeft  ;
var dimensionInfoRight ;
var dimensionInfoTop   ;
var dimensionInfoBottom;
var dimensionInfoWidth ;
var dimensionInfoHeight;
var dimensionInfoDeltaX;
var dimensionInfoDeltaY;

var toolTip;
var tooltipTextX;
var tooltipTextY;
var tooltipLabelX;
var tooltipLabelY;

var viewBoxOriginal;
var j;
//..............................................................................

//..............................................................................
function getSubDocument(embedding_element)
{
    if (embedding_element.contentDocument)
    {
        console.log('content doc' + embedding_element.contentDocument);

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

        console.log('subdoc' + subdoc);

        return subdoc;
    }
}
//..............................................................................

//..............................................................................
function findDiagramSVGElements()
{
    var svgObjects = document.querySelectorAll(".emb");

    for (var i = 0; i < svgObjects.length; i++)
    {
        var subDoc = getSubDocument(svgObjects[i]);
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

                for (j = 0; j < elementsDiagram.length; j++)
                {

                    elementsDiagram[j].setAttribute('cursor', 'default' );
                }
                viewBoxOriginal = diagram.getAttribute('viewBox');

                diagram.setAttribute('viewBox', '-2410 -1710 4820 3420');

                findBounds();
            }

            if (root.getAttribute('id') === editorIDString)
            {
                console.log('Found Editor');

                editor = root;

                elementsEditor = editor.querySelectorAll('*');

                coordinates         = editor.getElementById('coordinates'        );
                infoBox             = editor.getElementById('info-box'           );
                dimensionsBox       = editor.getElementById('dimensions-box'     );
                buttons             = editor.getElementById('buttons'            );
                diagramBackground   = editor.getElementById('diagramBackground'  );
                crosshairsBlue      = editor.getElementById('crosshairs-blue'    );

                elementX            = coordinates.getElementById('elementX'           );
                elementY            = coordinates.getElementById('elementY'           );

                elementInfoCap      = infoBox      .getElementById        ('elementInfoCap'     );
                elementInfoX        = infoBox      .getElementById        ('elementInfoX'       );
                elementInfoY        = infoBox      .getElementById        ('elementInfoY'       );
                elementInfoLeft     = infoBox      .getElementById        ('elementInfoLeft'    );
                elementInfoRight    = infoBox      .getElementById        ('elementInfoRight'   );
                elementInfoTop      = infoBox      .getElementById        ('elementInfoTop'     );
                elementInfoBottom   = infoBox      .getElementById        ('elementInfoBottom'  );
                elementInfoWidth    = infoBox      .getElementById        ('elementInfoWidth'   );
                elementInfoHeight   = infoBox      .getElementById        ('elementInfoHeight'  );

                dimensionInfoLeft   = dimensionsBox.getElementById        ('dimensionInfoLeft'  );
                dimensionInfoRight  = dimensionsBox.getElementById        ('dimensionInfoRight' );
                dimensionInfoTop    = dimensionsBox.getElementById        ('dimensionInfoTop'   );
                dimensionInfoBottom = dimensionsBox.getElementById        ('dimensionInfoBottom');
                dimensionInfoWidth  = dimensionsBox.getElementById        ('dimensionInfoWidth' );
                dimensionInfoHeight = dimensionsBox.getElementById        ('dimensionInfoHeight');
                dimensionInfoDeltaX = dimensionsBox.getElementById       ('dimensionInfoDeltaX' );
                dimensionInfoDeltaY = dimensionsBox.getElementById        ('dimensionInfoDeltaY');

                gridTarget       = editor.getElementById('grid-target'  );

                elementsGridTarget = gridTarget.querySelectorAll('*');

                tooltipTextX     = editor.getElementById('tooltipTextX' );
                tooltipTextY     = editor.getElementById('tooltipTextY' );
                tooltipLabelX    = editor.getElementById('tooltipLabelX');
                tooltipLabelY    = editor.getElementById('tooltipLabelY');

                highlightRect    = editor.getElementById('highlight-rect');

                console.log(highlightRect);

                for (j = 0; j < elementsEditor.length; j++)
                {
                    elementsEditor[j].setAttribute('cursor', 'default' );
                }
            }
            if (root.getAttribute('id') === tooltipIDString)
            {
                console.log('Found Tooltip');

                toolTip = root;

                gridTarget       = toolTip.getElementById('grid-target'  );

                tooltipTextX     = toolTip.getElementById('tooltipTextX' );
                tooltipTextY     = toolTip.getElementById('tooltipTextY' );
                tooltipLabelX    = toolTip.getElementById('tooltipLabelX');
                tooltipLabelY    = toolTip.getElementById('tooltipLabelY');

                elementsTooltip = toolTip.querySelectorAll('*');

                for (j = 0; j < elementsTooltip.length; j++)
                {
                    elementsTooltip[j].setAttribute('cursor', 'default' );
                }

                viewBoxOriginal = diagram.getAttribute('viewBox');
            }
        }
    }

    return elementsAll;
}
//..............................................................................

//..............................................................................

var viewBoxCalculated   = '';
var viewBoxCentred      = '';
var dimensions          = {};
var elementID;
var elementCaption;

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
function isDiagramComponent(elementID)
{
    if (elementID.indexOf('connector'  ) === 0) return false;
    if (elementID.indexOf('coordinates') === 0) return false;
    if (elementID.indexOf('dimensions' ) === 0) return false;
    if (elementID.indexOf('diagram'    ) === 0) return false;
    if (elementID.indexOf('text'       ) === 0) return false;
    if (elementID.indexOf('tool'       ) === 0) return false;
    if (elementID.indexOf('info-box'   ) === 0) return false;
    if (elementID.indexOf('button'     ) === 0) return false;
    if (elementID.indexOf('grid'       ) === 0) return false;

    return elementID.length > 0;
}
//..............................................................................

//..............................................................................
function isDiagramElement(elementID)
{
    if (elementID.indexOf('connector') === 0) return true;

    return elementID.indexOf('component') === 0;
}
//..............................................................................

//..............................................................................
function isInfoClass(element)
{
    if (element.getAttribute('class') === 'refresh') return true;
    if (element.getAttribute('class') === 'coords')  return true;

    return element.getAttribute('class') === 'info';
}
//..............................................................................

//..............................................................................
function isOnHundredGrid(location)
{
    var x = Math.abs(location.x);
    var y = Math.abs(location.y);

    while(x > 0) x = x -100;
    while(y > 0) y = y -100;

    return x === 0 && y === 0;
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
    if (isInfoClass(evt.target))
    {
        tooltipTextX.setAttribute('opacity', '0');
        tooltipTextY.setAttribute('opacity', '0');
    }
    else
    {
        tooltipTextX.setAttribute('opacity', '1');
        tooltipTextY.setAttribute('opacity', '1');
    }

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

    var gridTargetCoords = mouseCoords;

    elementX.firstChild.data  = mouseCoords.x;
    elementY.firstChild.data  = mouseCoords.y;

    tooltipTextX.setAttribute('x', mouseCoords.x - 20);
    tooltipTextX.setAttribute('y', mouseCoords.y  -1);

    tooltipTextY.setAttribute('x', mouseCoords.x -20);
    tooltipTextY.setAttribute('y', mouseCoords.y +10);

    tooltipLabelX.setAttribute('x', mouseCoords.x - 60);
    tooltipLabelX.setAttribute('y', mouseCoords.y  -1);

    tooltipLabelY.setAttribute('x', mouseCoords.x -60);
    tooltipLabelY.setAttribute('y', mouseCoords.y +10);

    gridTarget.setAttribute("x", gridTargetCoords.x);
    gridTarget.setAttribute("y", gridTargetCoords.y);

    if (isOnHundredGrid(gridTargetCoords))
    {
        gridTarget.setAttribute('stroke-width', '0.5');
        gridTarget.setAttribute('stroke', 'purple');
    }
    else
    {
        gridTarget.setAttribute('stroke-width', '0.25');
        gridTarget.setAttribute('stroke', 'red');
    }

    tooltipTextX.firstChild.data   = mouseCoords.x;
    tooltipTextY.firstChild.data   = mouseCoords.y;
    tooltipLabelX.firstChild.data  = 'X: ';
    tooltipLabelY.firstChild.data  = 'Y: ';

    elementID      = element.getAttribute("id");

    elementCaption = element.getAttribute("caption") || elementID;

    if (elementID)
    {
        if (isDiagramComponent(elementID))
        {
            elementInfoCap   .firstChild.data  = elementCaption;
            elementInfoX     .firstChild.data  = element       .getAttribute("x");
            elementInfoY     .firstChild.data  = element       .getAttribute("y");

            elementInfoLeft  .firstChild.data  = elementBounds .left                        .toFixed(2);
            elementInfoRight .firstChild.data  = elementBounds .right                       .toFixed(2);
            elementInfoTop   .firstChild.data  = elementBounds .top                         .toFixed(2);
            elementInfoBottom.firstChild.data  = elementBounds .bottom                      .toFixed(2);
            elementInfoWidth .firstChild.data  = (elementBounds.right  - elementBounds.left).toFixed(2);
            elementInfoHeight.firstChild.data  = (elementBounds.bottom - elementBounds.top ).toFixed(2);
        }
        else
        {
            elementInfoCap   .firstChild.data  = '';
            elementInfoX     .firstChild.data  = '';
            elementInfoY     .firstChild.data  = '';
            elementInfoLeft  .firstChild.data  = '';
            elementInfoRight .firstChild.data  = '';
            elementInfoTop   .firstChild.data  = '';
            elementInfoBottom.firstChild.data  = '';
            elementInfoWidth .firstChild.data  = '';
            elementInfoHeight.firstChild.data  = '';
        }
    }
}
//..............................................................................

//..............................................................................
function mouseOut(evt)
{
    elementX.firstChild.data  = '';
    elementY.firstChild.data  = '';

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
    // location.reload();
}
//..............................................................................

//..............................................................................
function findBounds()
{
    console.log('Bounds     : ' );
    var domRectPointTL  = diagram.createSVGPoint();
    var domRectPointBR  = diagram.createSVGPoint();


    var message = '';

    dimensions.left   = 0;
    dimensions.top    = 0;
    dimensions.right  = 0;
    dimensions.bottom = 0;

    for (var i = 0; i < elementsAll.length; i++)
    {
        var elementID = elementsAll[i].getAttribute("id");

        if (elementID)
        {
            if (isDiagramElement(elementID))
            {
                var domRect = elementsAll[i].getBoundingClientRect();

                domRectPointTL.x = domRect.left;
                domRectPointTL.y = domRect.top;
                domRectPointBR.x = domRect.right;
                domRectPointBR.y = domRect.bottom;

                domRectPointTL = domRectPointTL.matrixTransform(diagram.getScreenCTM().inverse());
                domRectPointBR = domRectPointBR.matrixTransform(diagram.getScreenCTM().inverse());

                if (domRectPointTL.y < dimensions.top   ) dimensions.top    = domRectPointTL.y.toFixed(2);
                if (domRectPointTL.x < dimensions.left  ) dimensions.left   = domRectPointTL.x.toFixed(2);
                if (domRectPointBR.y > dimensions.bottom) dimensions.bottom = domRectPointBR.y.toFixed(2);
                if (domRectPointBR.x > dimensions.right ) dimensions.right  = domRectPointBR.x.toFixed(2);
            }
        }
    }

    dimensions.width       = (dimensions.right  - dimensions.left).toFixed(2);
    dimensions.height      = (dimensions.bottom - dimensions.top ).toFixed(2);

    dimensions.deltaTop    = (dimensions.top  - diagramBackground.getAttribute('y')).toFixed(2);
    dimensions.deltaLeft   = (dimensions.left - diagramBackground.getAttribute('x')).toFixed(2);

    dimensions.deltaBottom = ((Number(diagramBackground.getAttribute('height')) + Number(diagramBackground.getAttribute('y')) - dimensions.bottom) * -1).toFixed(2);
    dimensions.deltaRight  = (Number(diagramBackground.getAttribute('width' )) + Number(diagramBackground.getAttribute('x')) - dimensions.right) * -1;

    dimensions.deltaX = ((dimensions.width /2)*(-1)  - dimensions.left).toFixed(2);
    dimensions.deltaY = ((dimensions.height /2)*(-1) - dimensions.top) .toFixed(2);

    dimensionInfoLeft  .firstChild.data = dimensions.left   +'\n';
    dimensionInfoRight .firstChild.data = dimensions.right  +'\n';
    dimensionInfoTop   .firstChild.data = dimensions.top    +'\n';
    dimensionInfoBottom.firstChild.data = dimensions.bottom +'\n';
    dimensionInfoWidth .firstChild.data = dimensions.width  +'\n';
    dimensionInfoHeight.firstChild.data = dimensions.height +'\n';

    dimensionInfoDeltaX.firstChild.data = dimensions.deltaX +'\n';
    dimensionInfoDeltaY.firstChild.data = dimensions.deltaY +'\n';

    viewBoxCalculated = ' ' + dimensions.left + ' ' + dimensions.top + ' ' + dimensions.width + ' ' + dimensions.height;

    viewBoxCentred = (dimensions.width /2)*(-1) + ' ' + (dimensions.height /2)*(-1) + ' ' + dimensions.width + ' ' + dimensions.height; ;

    console.log('viewBox Calculated: ' + viewBoxCalculated);
    console.log('viewBox Centred   : ' + viewBoxCentred   );
}
//..............................................................................

//..............................................................................
function buttonMouseMove(evt)
{
    evt.target.setAttribute('opacity', '0.7');

    mouseMove(evt)
}
//..............................................................................

//..............................................................................
function buttonMouseOut(evt)
{
    evt.target.setAttribute('opacity', '1');

    mouseOut(evt)
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
function saveFile()
{
    for (var i = 0; i < elementsAll.length; i++)
    {
        if (elementsAll[i].getAttribute('class') === 'centre-spot')
        {
            if (elementsAll[i]) elementsAll[i].remove();
        }
        if (elementsAll[i].getAttribute('class') === 'center-spot')
        {
            if (elementsAll[i]) elementsAll[i].remove();
        }
    }
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
function viewBoxClick(evt)
{
    infoBox      .setAttribute('x', dimensions.deltaRight  );
    infoBox      .setAttribute('y', dimensions.deltaBottom );
    dimensionsBox.setAttribute('x', dimensions.deltaRight  );
    dimensionsBox.setAttribute('y', dimensions.deltaTop    );
    buttons      .setAttribute('x', dimensions.deltaLeft   );
    buttons      .setAttribute('y', dimensions.deltaTop    );
    coordinates  .setAttribute('x', dimensions.deltaLeft   );
    coordinates  .setAttribute('y', dimensions.deltaBottom );

    diagramBackground.setAttribute('opacity', '0');

    infoBox       .setAttribute('opacity', '0');
    dimensionsBox .setAttribute('opacity', '0');
    buttons       .setAttribute('opacity', '0');
    coordinates   .setAttribute('opacity', '0');
    crosshairsBlue.setAttribute('opacity', '0');

    if (diagram.getAttribute('viewBox') === viewBoxCalculated)
    {
        diagram.setAttribute("viewBox", viewBoxOriginal);

        infoBox      .setAttribute('x', '0');
        infoBox      .setAttribute('y', '0');
        dimensionsBox.setAttribute('x', '0');
        dimensionsBox.setAttribute('y', '0');
        buttons      .setAttribute('x', '0');
        buttons      .setAttribute('y', '0');
        coordinates  .setAttribute('x', '0');
        coordinates  .setAttribute('y', '0');

        diagramBackground      .setAttribute('opacity', '1');

        infoBox       .setAttribute('opacity', '1');
        dimensionsBox .setAttribute('opacity', '1');
        buttons       .setAttribute('opacity', '1');
        coordinates   .setAttribute('opacity', '1');
        crosshairsBlue.setAttribute('opacity', '1');
    }
    else
    {
        diagram.setAttribute("viewBox", viewBoxCalculated);
    }

    for (var i = 0; i < elementsAll.length; i++)
    {
        if(elementsAll[i].getAttribute('x'))
        {
            var x = elementsAll[i].getAttribute('x');
        }
        if(elementsAll[i].getAttribute('y'))
        {
            var y = elementsAll[i].getAttribute('y');
        }

        var deltaX = (Number(x) + Number(dimensions.deltaX)).toFixed(2);
        var deltaY = (Number(y) + Number(dimensions.deltaY)).toFixed(2);

        if (isNaN(deltaX))
        {
            deltaX = 0;
        }

        if (isNaN(deltaY))
        {
            deltaY = 0;
        }
    }

    saveFile();
}
//..............................................................................

//..............................................................................
function isGridElement(element)
{
    if (element.getAttribute('id').indexOf('grid') > -1) return true;
}
//..............................................................................

//..............................................................................
function isModuleElement(element)
{
    if (element.getAttribute('id').indexOf('module') > -1) return true;
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
    for (var i = 0; i < elementsAll.length; i++)
    {
        if (elementsAll[i].getAttribute('class') === 'viewBox')
        {
            elementsAll[i].addEventListener('click'    , viewBoxClick );
            elementsAll[i].addEventListener('mousemove', buttonMouseMove);
            elementsAll[i].addEventListener('mouseout' , buttonMouseOut );
        }
        else if (elementsAll[i].getAttribute('class') === 'refresh')
        {
            elementsAll[i].addEventListener('click'    , refreshClick );
            elementsAll[i].addEventListener('mousemove', buttonMouseMove);
            elementsAll[i].addEventListener('mouseout' , buttonMouseOut );
        }
        else if (elementsAll[i].getAttribute('class') === 'buttons')
        {
        }
        else
        {
            elementsAll[i].addEventListener('click'    , onClick  );
            elementsAll[i].addEventListener('mousemove', mouseMove);
            elementsAll[i].addEventListener('mouseout' , mouseOut );
            elementsAll[i].addEventListener('resize'   , onResize);
        }

        // console.log('Adding: ' + elementsAll[i].getAttribute('id'));

        if (elementsAll[i].getAttribute('id'))
        {
            if (!isModuleElement(elementsAll[i]) && !isGridElement(elementsAll[i]))
            {
                elementsAll[i].setAttribute('opacity', '0.95')
            }
        }
    }
}
//..............................................................................

//..............................................................................
