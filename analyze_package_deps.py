#!/usr/bin/env python3

import xml.etree.ElementTree as ET
import os
import collections

def analyze_package_dependencies():
    package_files = []
    for root, dirs, files in os.walk('.'):
        for file in files:
            if file == 'package.xml':
                package_files.append(os.path.join(root, file))

    package_files = sorted(package_files)

    dependency_types = collections.defaultdict(list)
    all_dependencies = collections.defaultdict(list)

    for package_file in package_files:
        try:
            tree = ET.parse(package_file)
            root_elem = tree.getroot()

            package_name = None
            package_version = None

            for child in root_elem:
                if child.tag == 'name':
                    package_name = child.text
                if child.tag == 'version':
                    package_version = child.text

            if not package_name:
                continue

            package_info = {
                'path': package_file,
                'version': package_version
            }

            for child in root_elem:
                if 'depend' in child.tag or 'depend' in child.attrib:
                    dep_name = None
                    dep_version = None

                    if child.find('name') is not None:
                        dep_name = child.find('name').text
                    else:
                        dep_name = child.text

                    if 'version' in child.attrib:
                        dep_version = child.attrib['version']
                    elif child.find('version') is not None:
                        dep_version = child.find('version').text

                    dep_info = {
                        'name': dep_name,
                        'version': dep_version,
                        'type': child.tag
                    }

                    all_dependencies[package_name].append(dep_info)
                    dependency_types[child.tag].append((package_name, dep_name, package_file))

        except Exception as e:
            print(f"Error parsing {package_file}: {e}")
            continue

    return all_dependencies, dependency_types, package_files

def generate_dependency_report(all_dependencies, dependency_types, package_files):
    print(f"=== Kalibr项目package.xml依赖分析报告 ===\n")
    print(f"分析的package.xml文件数量: {len(package_files)}\n")

    print(f"=== 依赖类型统计 ===\n")
    for dep_type, deps in sorted(dependency_types.items()):
        print(f"{dep_type}: {len(deps)} 个依赖")

    print(f"\n=== 各package.xml文件的依赖数量 ===\n")
    for package_name, deps in sorted(all_dependencies.items(), key=lambda x: len(x[1]), reverse=True):
        print(f"{package_name:40} : {len(deps)} 个依赖")

    print(f"\n=== 高频依赖分析 ===\n")
    dep_counter = collections.defaultdict(int)
    for package_name, deps in all_dependencies.items():
        for dep in deps:
            dep_counter[dep['name']] += 1

    for dep_name, count in sorted(dep_counter.items(), key=lambda x: x[1], reverse=True):
        if count >= 3:
            print(f"{dep_name:40} : 在 {count} 个package.xml中被依赖")

    print(f"\n=== 依赖类型分布详情 ===\n")
    for dep_type, deps in sorted(dependency_types.items()):
        print(f"\n--- {dep_type} ({len(deps)} 个) ---")
        package_deps = collections.defaultdict(list)
        for package_name, dep_name, file_path in deps:
            package_deps[package_name].append(dep_name)

        for package_name, deps_list in sorted(package_deps.items()):
            print(f"{package_name:40} : {', '.join(deps_list)}")

    print(f"\n=== 文件路径 ===\n")
    for file_path in package_files:
        print(file_path)

if __name__ == "__main__":
    try:
        all_dependencies, dependency_types, package_files = analyze_package_dependencies()
        generate_dependency_report(all_dependencies, dependency_types, package_files)

        # 写入报告到文件
        with open('/home/xcandy/Workspace/kalibr/docs/ros_dependency_analysis/package_xml_analysis.txt', 'w', encoding='utf-8') as f:
            import sys
            stdout = sys.stdout
            sys.stdout = f
            generate_dependency_report(all_dependencies, dependency_types, package_files)
            sys.stdout = stdout
        print("\n报告已保存到: /home/xcandy/Workspace/kalibr/docs/ros_dependency_analysis/package_xml_analysis.txt")

    except Exception as e:
        print(f"Error: {e}")
        import traceback
        print(traceback.format_exc())
