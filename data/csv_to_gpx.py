from pathlib import Path
from argparse import ArgumentParser
import xml.etree.cElementTree as ET
from xml.dom import minidom

def csv_to_gpx(csv_path: str):
    gpx_node = ET.Element("gpx", version="1.0")
    name_node = ET.SubElement(gpx_node, "name").text = Path(csv_path).stem

    with open(csv_path) as csv_file:
        for i, line in enumerate(csv_file):
            if i == 0:
                continue
            # INDEX;TIMESTAMP;LATITUDE;LONGITUDE;HORIZONTAL_ACCURACY;VERTICAL_ACCURACY;SPEED;SPEED_ACCURACY;ALTITUDE;COURSE;COURSE_ACCURACY;TRANSITION_TO
            (idx, ts, lat, lon, h_acc, v_acc, speed, speed_acc, alt, course, course_acc, genre) = line.split(";")

            wpt_node = ET.SubElement(gpx_node, "wpt", lat=lat, lon=lon).text = ""

    xml_string = minidom.parseString(
        ET.tostring(gpx_node, short_empty_elements=True, encoding="utf8", method="xml")).toprettyxml(indent="   ")
    
    with open(str(Path(csv_path).with_suffix(".gpx").absolute()), "w") as f:
        f.write(xml_string)
    
    

if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("csv_path")
    args = parser.parse_args()
    csv_to_gpx(args.csv_path)