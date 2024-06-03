import 'package:flutter/material.dart';
import '../api/api_constants.dart';
import '../api/api_service.dart';
import '../common_dtos/reponse_dto.dart';

class FetchListPagination<T> {
  ///==> used very specifically in Future.Builder flows.
  //==> 1) This class will deal with fetching of lists and its pagination if enabled
  //==> 2) You pass the classDto in TypeInference parameter and its .fromJson and the URl of the api.
  // Assuming the parameters of each list fetching url are the same
  //==> 3) if you pass searchParam,sort,searchString as non null value, the pagination will reset to 0-100 offest.
  //==> 4) if you do not pass searchParam,sort,searchString, then alreadyFetchedOffset will increment by the batchSize amount,
  // until the api starts returning empty values, then the calling this function will return empty array.

  /* EXAMPLE
  FetchListPagination<EmployeeDto> fetchEmployeeList =
      FetchListPagination<EmployeeDto>(
    urlString: ApiConstants.getEmployeeList,
    fromJsonConverter: (json) => EmployeeDto.fromJson(json),
  );
EXAMPLE */

  FetchListPagination({
    required this.urlString,
    required this.fromJsonConverter,
  });

  final T Function(Map<String, dynamic>) fromJsonConverter;
  final String urlString;
  int upperLimitOffset = 0; //last offset that was fetched
  int batchSize = 100;
  bool isMoreDataAvailable = true;
  String? searchParam;
  String? sort;
  String? searchString;
  bool isLoading = false;
  bool enablePagination = false;

  Future<List<T>> fetchList(BuildContext context,
      {String? searchParam, String? sort, String? searchString}) async {
    isLoading = true;
    if ((searchParam != null) || (sort != null) || (searchString != null)) {
      upperLimitOffset = 0;
      isMoreDataAvailable = true;
    } else {
      if (!enablePagination) {
        return [];
      }
    }

    if (!isMoreDataAvailable) {
      isLoading = false;
      return [];
    }

    this.searchParam = searchParam ?? this.searchParam;
    this.sort = sort ?? this.sort;
    this.searchString = searchString ?? this.searchString;

    int lowerLimitOffset = upperLimitOffset;
    upperLimitOffset += batchSize;

    try {
      ResponseDto response = ResponseDto.fromJson(
        await ApiService().requestGetApi(endPoint: ''),
      );

      if (response.success) {
        List<T> list = response.data == null
            ? []
            : List<T>.from(
          response.data.map(
                (x) => fromJsonConverter(x),
          ),
        );

        if (list.isEmpty) {
          isMoreDataAvailable = false;
        }
        isLoading = false;
        return list;
      } else {
        throw '';
      }
    } catch (e) {
      isLoading = false;
      rethrow;
    }
  }
}

