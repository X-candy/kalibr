#!/usr/bin/env python3

import os
import re
import collections

def find_cmake_files():
    cmake_files = []
    for root, dirs, files in os.walk('.'):
        for file in files:
            if file == 'CMakeLists.txt':
                cmake_files.append(os.path.join(root, file))
    return sorted(cmake_files)

def analyze_cmake_file(file_path):
    findings = {
        'catkin_required': [],
        'catkin_simple': [],
        'custom_macros': [],
        'python_setup': [],
        'add_python_export': [],
        'boost_find': [],
        'eigen_find': [],
        'opencv_find': [],
        'suitesparse_find': [],
        'tbb_find': [],
        'cpp_standard': [],
        'project_name': None,
        'libraries': [],
        'executables': [],
        'tests': []
    }

    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()

        # 提取项目名称
        project_match = re.search(r'project\s*\(\s*([^)\s]+)', content)
        if project_match:
            findings['project_name'] = project_match.group(1)

        # 查找catkin相关
        if 'find_package(catkin' in content:
            findings['catkin_required'].append(file_path)

        if 'catkin_simple' in content:
            findings['catkin_simple'].append(file_path)

        if 'catkin_python_setup()' in content:
            findings['python_setup'].append(file_path)

        if 'add_python_export_library' in content:
            findings['add_python_export'].append(file_path)

        # 查找自定义宏和函数
        if 'add_python_export_library' in content:
            findings['custom_macros'].append('add_python_export_library')
        if 'cs_install' in content:
            findings['custom_macros'].append('cs_install')
        if 'cs_add_library' in content:
            findings['custom_macros'].append('cs_add_library')

        # 查找依赖查找
        if 'find_package(Boost' in content:
            findings['boost_find'].append(file_path)
        if 'find_package(Eigen3' in content or 'find_package(Eigen' in content:
            findings['eigen_find'].append(file_path)
        if 'find_package(OpenCV' in content:
            findings['opencv_find'].append(file_path)
        if 'find_package(suitesparse' in content or 'find_package(SuiteSparse' in content:
            findings['suitesparse_find'].append(file_path)
        if 'find_package(TBB' in content or 'find_package(tbb' in content:
            findings['tbb_find'].append(file_path)

        # C++标准
        cpp_std_matches = re.findall(r'set\s*\(\s*CMAKE_CXX_STANDARD\s+(\d+)', content)
        if cpp_std_matches:
            findings['cpp_standard'].extend(cpp_std_matches)

        # 查找库和可执行文件
        lib_matches = re.findall(r'add_library\s*\(\s*([^)\s]+)', content)
        findings['libraries'].extend(lib_matches)

        exe_matches = re.findall(r'add_executable\s*\(\s*([^)\s]+)', content)
        findings['executables'].extend(exe_matches)

        # 查找测试
        if 'catkin_add_gtest' in content or 'add_test' in content or 'CATKIN_ENABLE_TESTING' in content:
            findings['tests'].append(file_path)

    except Exception as e:
        print(f"Error reading {file_path}: {e}")

    return findings

def generate_cmake_report(cmake_files):
    print(f"=== Kalibr项目CMakeLists.txt分析报告 ===\n")
    print(f"分析的CMakeLists.txt文件数量: {len(cmake_files)}\n")

    all_findings = {
        'total_catkin_required': 0,
        'total_catkin_simple': 0,
        'total_python_setup': 0,
        'total_add_python_export': 0,
        'total_boost_find': 0,
        'total_eigen_find': 0,
        'total_opencv_find': 0,
        'total_suitesparse_find': 0,
        'total_tbb_find': 0,
        'cpp_standards': set(),
        'custom_macros': set(),
        'all_projects': [],
        'test_files': []
    }

    project_details = []

    for cmake_file in cmake_files:
        findings = analyze_cmake_file(cmake_file)
        project_details.append((cmake_file, findings))

        if findings['catkin_required']:
            all_findings['total_catkin_required'] += 1
        if findings['catkin_simple']:
            all_findings['total_catkin_simple'] += 1
        if findings['python_setup']:
            all_findings['total_python_setup'] += 1
        if findings['add_python_export']:
            all_findings['total_add_python_export'] += 1
        if findings['boost_find']:
            all_findings['total_boost_find'] += 1
        if findings['eigen_find']:
            all_findings['total_eigen_find'] += 1
        if findings['opencv_find']:
            all_findings['total_opencv_find'] += 1
        if findings['suitesparse_find']:
            all_findings['total_suitesparse_find'] += 1
        if findings['tbb_find']:
            all_findings['total_tbb_find'] += 1

        all_findings['cpp_standards'].update(findings['cpp_standard'])
        all_findings['custom_macros'].update(findings['custom_macros'])

        if findings['project_name']:
            all_findings['all_projects'].append((findings['project_name'], cmake_file))

        if findings['tests']:
            all_findings['test_files'].append(cmake_file)

    # 打印报告
    print("=== 构建系统特性统计 ===\n")
    print(f"使用catkin的项目: {all_findings['total_catkin_required']}")
    print(f"使用catkin_simple的项目: {all_findings['total_catkin_simple']}")
    print(f"使用catkin_python_setup的项目: {all_findings['total_python_setup']}")
    print(f"使用add_python_export_library的项目: {all_findings['total_add_python_export']}")
    print(f"\n使用Boost的项目: {all_findings['total_boost_find']}")
    print(f"使用Eigen的项目: {all_findings['total_eigen_find']}")
    print(f"使用OpenCV的项目: {all_findings['total_opencv_find']}")
    print(f"使用SuiteSparse的项目: {all_findings['total_suitesparse_find']}")
    print(f"使用TBB的项目: {all_findings['total_tbb_find']}")
    print(f"\n使用的C++标准: {sorted(all_findings['cpp_standards'])}")
    print(f"自定义CMake宏: {sorted(all_findings['custom_macros'])}")
    print(f"\n包含测试的项目: {len(all_findings['test_files'])}")

    print(f"\n=== 所有项目列表 ===\n")
    for project_name, file_path in sorted(all_findings['all_projects']):
        print(f"{project_name:40} : {file_path}")

    print(f"\n=== 使用add_python_export_library的项目 ===\n")
    for file_path, findings in project_details:
        if findings['add_python_export']:
            print(f"{file_path}")

    print(f"\n=== 使用catkin_simple的项目 ===\n")
    for file_path, findings in project_details:
        if findings['catkin_simple']:
            print(f"{file_path}")

    print(f"\n=== 包含测试的项目 ===\n")
    for test_file in all_findings['test_files']:
        print(f"{test_file}")

    print(f"\n=== 文件路径列表 ===\n")
    for cmake_file in cmake_files:
        print(f"{cmake_file}")

    return all_findings, project_details

if __name__ == "__main__":
    try:
        cmake_files = find_cmake_files()
        all_findings, project_details = generate_cmake_report(cmake_files)

        # 写入报告到文件
        with open('/home/xcandy/Workspace/kalibr/docs/ros_dependency_analysis/cmake_analysis.txt', 'w', encoding='utf-8') as f:
            import sys
            stdout = sys.stdout
            sys.stdout = f
            generate_cmake_report(cmake_files)
            sys.stdout = stdout
        print("\n报告已保存到: /home/xcandy/Workspace/kalibr/docs/ros_dependency_analysis/cmake_analysis.txt")

    except Exception as e:
        print(f"Error: {e}")
        import traceback
        print(traceback.format_exc())
