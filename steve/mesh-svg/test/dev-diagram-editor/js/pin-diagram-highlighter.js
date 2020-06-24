//..............................................................................

var svg             = document    .getElementById        ('pin-layout-diagram');
var elementsNet     = svg         .getElementsByClassName('elements-net'      );
var elementsNoNet   = svg         .getElementsByClassName('no-net'            );
var displayGroup    = svg         .getElementById        ('displayGroup'      );
var crossHairs      = svg         .getElementById        ('cross-hairs'        );
var displayTextNet  = displayGroup.getElementsByTagName  ('text'              )[0];
var displayTextRef  = displayGroup.getElementsByTagName  ('text'              )[1];
var displayPad      = displayGroup.getElementsByTagName  ('circle'            )[0];
var captionElement  = svg         .getElementById        ('captionElement'    );
var descElement0    = svg         .getElementById        ('descElement0'      );
var descElement1    = svg         .getElementById        ('descElement1'      );
var textBoxElement  = svg         .getElementById        ('textBoxElement'    );
var outline         = svg         .getElementById        ('outline'           );
var heatPadGroup    = svg         .getElementById        ('heat-pad-group'    );

if (heatPadGroup !== null)
{
    var heatPad         = heatPadGroup.getElementsByTagName  ('rect'              ) [0];
}
const opacityFaded = 0.4;

var descriptionSplitLength = 45;

var parent;
var net = '';

addEventListeners();

//..............................................................................

//..............................................................................
const colors =
{
    color__gold      : "#ebb300",
    color__PadDefault: '#c0c0c0',
};
//..............................................................................

//..............................................................................
function positionCrossHairs(x, y)
{
    crossHairs.setAttribute("x", x);
    crossHairs.setAttribute("y", y);
    crossHairs.setAttribute("visibility", "visible");
}
//..............................................................................

//..............................................................................
function hideCrossHairs()
{
    crossHairs.setAttribute("visibility", "hidden");
}
//..............................................................................

//..............................................................................
function getStringSplitPoint(s, descriptionSplitChar)
{
    if (s.length <  descriptionSplitLength) return 0;

    var indices = '';
    var middle = s.length/2;

    for (var i = 0; i < s.length; i++)
    {
        if (s[i] === descriptionSplitChar)
        {
            indices = indices + i + ','
        }
    }

    indices = indices.split(',');

    for (i = 0; i < indices.length; i++)
    {
        if (indices[i] > middle)
        {
            return indices[i];
        }
    }
}
//..............................................................................

//..............................................................................
function showHelpText(parent)
{
    var description = parent.getAttribute("description_en");
    var caption     = parent.getAttribute("caption_en"    );
    var descriptionSplitChar = ' ';

    var splitPoint = getStringSplitPoint(description, descriptionSplitChar);

    if (svg.getAttribute("language") === 'language_zh')
    {
        description = parent.getAttribute("description_zh") || description;
        caption     = parent.getAttribute("caption_zh"    ) || caption;

        if (description.indexOf('，') > -1)
        {
            splitPoint = description.indexOf('，') + 1;
        }
        else if (description.indexOf('。') > -1)
        {
            splitPoint = description.indexOf('。') + 1;
        }
    }

    captionElement.firstChild.data = caption;
    descElement1  .firstChild.data = '';

    if (splitPoint !== 0)
    {
        descElement0.firstChild.data = description.substring(0, splitPoint).trim();
        descElement1.firstChild.data = description.substring(   splitPoint).trim();
    }
    else
    {
        descElement0.firstChild.data = description.trim();
    }

    captionElement.setAttribute("visibility", "visible");
    descElement0  .setAttribute("visibility", "visible");
    descElement1  .setAttribute("visibility", "visible");
    textBoxElement.setAttribute("visibility", "visible");
}
//..............................................................................

//..............................................................................
function highlightGroupByNet(net)
{
    for(var i = 0; i < elementsNet.length; i++)
    {
        if (elementsNet[i].getAttribute("net") === net)
        {
            elementsNet[i].setAttribute("opacity", "1.0");
            elementsNet[i].setAttribute("visibility", "visible");
        }
    }
}
//..............................................................................

//..............................................................................
function setTargetCoordinates(evt)
{
    console.log(evt.target.parentNode.getAttribute("caption_en") + ': ' + evt.target.parentNode.getAttribute("fill"));

    try
    {
        var targetTextNet = parent.getElementsByTagName('text'  )[0];
        var targetTextRef = parent.getElementsByTagName('text'  )[1];
        var targetPad     = parent.getElementsByTagName('circle')[0];

        var fillColour = evt.target.parentNode.getAttribute("fill");

        var targetRef = targetTextRef.firstChild.data;

        var targetNetX = targetTextNet.getAttribute("x" );
        var targetRefX = targetTextRef.getAttribute("x" );
        var targetPadX = targetPad    .getAttribute("cx");

        var targetNetY = targetTextNet.getAttribute("y" );
        var targetRefY = targetTextRef.getAttribute("y" );
        var targetPadY = targetPad    .getAttribute("cy");

        displayTextNet.setAttribute("x",  targetNetX);
        displayTextRef.setAttribute("x",  targetRefX);
        displayPad    .setAttribute("cx", targetPadX);

        displayTextNet.setAttribute("y",  targetNetY);
        displayTextRef.setAttribute("y",  targetRefY);
        displayPad    .setAttribute("cy", targetPadY);

        if (fillColour === colors.color__PadDefault)
        {
            displayPad.setAttribute("fill", colors.color__gold);
        }
        else
        {
            displayPad.setAttribute("fill", fillColour);
        }

        displayTextRef.firstChild.data = targetRef;
        displayTextNet.firstChild.data = net;

        positionCrossHairs(targetPadX, targetPadY);
    }
    catch(error)
    {
        console.log('setTargetCoordinates Error: ' + error);
    }
}
//..............................................................................

//..............................................................................
function elementsNetMouseOver(evt)
{
    parent = evt.target.parentElement;
    net    = parent.getAttribute("net");

    setTargetCoordinates(evt);

    fadeAll();

    parent      .setAttribute("visibility", "hidden");
    displayGroup.setAttribute("visibility", "visible");

    highlightGroupByNet (net);

    showHelpText(parent);
}
//..............................................................................

//..............................................................................
function unFadeAll()
{
    for(var i = 0; i < elementsNet.length; i++)
    {
        elementsNet[i].setAttribute("opacity", "1.0");
        elementsNet[i].setAttribute("visibility", "visible");
    }

    for(i = 0; i < elementsNoNet.length; i++)
    {
        elementsNoNet[i].setAttribute("opacity", "1.0");
        elementsNoNet[i].setAttribute("visibility", "visible");
    }

    hideCrossHairs();
}
//..............................................................................

//..............................................................................
function fadeAll()
{
    for(i = 0; i < elementsNet.length; i++)
    {
        elementsNet[i].setAttribute("opacity", opacityFaded);
    }

    for(i = 0; i < elementsNoNet.length; i++)
    {
        elementsNoNet[i].setAttribute("opacity", opacityFaded);
    }
}
//..............................................................................

//..............................................................................
function sleep(milliseconds)
{
    var start = new Date().getTime();

    for (var i = 0; i < 1e7; i++)
    {
        if ((new Date().getTime() - start) > milliseconds)
        {
            break;
        }
    }
}
//..............................................................................

//..............................................................................
function hideHelpText(evt)
{
    try
    {
        if (parent === evt.target.parentElement)
        {
            return;
        }

        if (parent === null) return;

        parent  .setAttribute("visibility", "visible");

        captionElement.setAttribute("visibility", "visible");
        descElement0  .setAttribute("visibility", "visible");
        descElement1  .setAttribute("visibility", "visible");
        textBoxElement.setAttribute("visibility", "visible");

        unFadeAll();
    }
    catch(error)
    {
        console.log('Parent: ' + parent.document);
    }

    sleep(200);
}
//..............................................................................

//..............................................................................
function showParent()
{
    sleep(200);

    parent.setAttribute("visibility", "visible");
}
//..............................................................................

//..............................................................................
function miscMouseMove(evt)
{
    unFadeAll();

    hideHelpText(evt);

    sleep(200);

    captionElement.setAttribute("visibility", "hidden");
    descElement0  .setAttribute("visibility", "hidden");
    descElement1  .setAttribute("visibility", "hidden");
    displayGroup  .setAttribute("visibility", "hidden");
    textBoxElement.setAttribute("visibility", "hidden");
}
//..............................................................................

//..............................................................................
function elementsNoNetMouseOver()
{
    unFadeAll();
}
//..............................................................................

//..............................................................................
function heatPadMouseMove(evt)
{
    parent = evt.target.parentElement;
    net    = parent.getAttribute("net");

    fadeAll();

    highlightGroupByNet (net);

    showHelpText(parent);
}
//..............................................................................

//..............................................................................
function addEventListeners()
{
    outline        .addEventListener('mousemove', miscMouseMove         );

    displayTextNet .addEventListener('mouseover', showParent            );
    captionElement .addEventListener('mousemove', elementsNoNetMouseOver);
    descElement0   .addEventListener('mousemove', elementsNoNetMouseOver);
    descElement1   .addEventListener('mousemove', elementsNoNetMouseOver);
    textBoxElement .addEventListener('mousemove', elementsNoNetMouseOver);

    if (heatPad !== null && heatPad !== undefined)
    {
        heatPad        .addEventListener('mousemove', heatPadMouseMove      );
    }

    for (var i = 0; i < elementsNet.length; i++)
    {
        elementsNet[i].addEventListener('mouseover', elementsNetMouseOver);
        elementsNet[i].addEventListener('mouseout' , hideHelpText);
    }

    for (i = 0; i < elementsNoNet.length; i++)
    {
        elementsNoNet[i].addEventListener('mouseover', elementsNoNetMouseOver);
    }
}
//..............................................................................

//..............................................................................
